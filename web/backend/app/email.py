# web/backend/app/email.py

import logging
import httpx
from datetime import datetime
from fastapi import BackgroundTasks
from app.config import settings

logger = logging.getLogger("app.email")

async def send_email_via_resend(to_email: str, subject: str, html_content: str):
    """Sends an email using the Resend API."""
    if not settings.RESEND_API_KEY:
        logger.warning(
            f"RESEND_API_KEY is not set. Cannot send email to {to_email}. "
            f"Subject: {subject}"
        )
        return

    url = "https://api.resend.com/emails"
    headers = {
        "Authorization": f"Bearer {settings.RESEND_API_KEY}",
        "Content-Type": "application/json",
    }
    payload = {
        "from": settings.MAIL_FROM,
        "to": [to_email],
        "subject": subject,
        "html": html_content,
    }

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(url, headers=headers, json=payload, timeout=10.0)
            if response.status_code not in (200, 201):
                logger.error(
                    f"Failed to send email to {to_email} via Resend. "
                    f"Status code: {response.status_code}, Response: {response.text}"
                )
            else:
                logger.info(f"Successfully sent email to {to_email} via Resend.")
    except Exception as e:
        logger.error(f"Error calling Resend API to send email to {to_email}: {e}")


def _log_email_to_console(to_email: str, subject: str, html_content: str):
    """Logs the email to console for development testing."""
    border = "=" * 80
    print(border)
    print(f"[{settings.ENVIRONMENT.upper()} EMAIL DEV-LOG]")
    print(f"From:    {settings.MAIL_FROM}")
    print(f"To:      {to_email}")
    print(f"Subject: {subject}")
    print("-" * 80)
    print(html_content)
    print(border)


def _wrap_email_template(title: str, content_html: str) -> str:
    """Wraps HTML content in a beautiful, premium, responsive email template."""
    current_year = datetime.now().year
    return f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{title}</title>
    </head>
    <body style="margin: 0; padding: 0; background-color: #f6f9fc; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #f6f9fc; padding: 40px 10px;">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 550px; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);">
                        <!-- Top Accent Line -->
                        <tr>
                            <td style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); height: 6px;"></td>
                        </tr>
                        
                        <!-- Content -->
                        <tr>
                            <td style="padding: 40px 32px;">
                                <!-- Header Logo / Name -->
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="padding-bottom: 24px; border-bottom: 1px solid #f1f5f9;">
                                            <span style="font-size: 20px; font-weight: 800; letter-spacing: -0.5px; color: #0f172a;">The Last Deploy</span>
                                        </td>
                                    </tr>
                                </table>
                                
                                <!-- Main Body -->
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-top: 32px;">
                                    <tr>
                                        <td>
                                            {content_html}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        
                        <!-- Footer -->
                        <tr>
                            <td style="background-color: #f8fafc; padding: 24px 32px; border-top: 1px solid #e2e8f0; text-align: center;">
                                <p style="margin: 0; font-size: 12px; color: #64748b; line-height: 1.5;">
                                    You received this email because you registered or requested a password change on <a href="{settings.FRONTEND_URL}" style="color: #10b981; text-decoration: none; font-weight: 600;">The Last Deploy</a>.
                                </p>
                                <p style="margin: 8px 0 0 0; font-size: 12px; color: #94a3b8;">
                                    &copy; {current_year} The Last Deploy. All rights reserved.
                                </p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    </html>
    """


def send_verification_email(email: str, token: str, background_tasks: BackgroundTasks):
    """Sends a verification email to the user (via background task)."""
    verify_url = f"{settings.FRONTEND_URL}/verify-email?token={token}"
    subject = "Verify Your The Last Deploy Account"
    
    body_html = f"""
    <h2 style="margin-top: 0; margin-bottom: 16px; font-size: 22px; font-weight: 700; color: #0f172a; line-height: 1.3;">Welcome to The Last Deploy!</h2>
    <p style="margin: 0 0 24px 0; font-size: 15px; line-height: 1.6; color: #475569;">
        Please verify your email address to active your account and start your DevOps practicing journey:
    </p>
    <p style="margin: 0 0 24px 0; text-align: center;">
        <a href="{verify_url}" style="display: inline-block; background-color: #10b981; color: #ffffff; padding: 12px 28px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 15px; box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);">
            Verify Email Address
        </a>
    </p>
    <p style="margin: 0 0 8px 0; font-size: 13px; color: #64748b;">
        If the button above does not work, copy and paste this link into your browser:
    </p>
    <p style="margin: 0 0 24px 0; font-size: 13px; word-break: break-all;">
        <a href="{verify_url}" style="color: #10b981; text-decoration: underline;">{verify_url}</a>
    </p>
    <p style="margin: 0; font-size: 15px; color: #475569; line-height: 1.6;">
        Happy learning,<br>
        <strong>The Last Deploy Team</strong>
    </p>
    """
    
    html_content = _wrap_email_template(subject, body_html)

    if settings.ENVIRONMENT == "development":
        _log_email_to_console(email, subject, html_content)
        
    if settings.RESEND_API_KEY:
        background_tasks.add_task(send_email_via_resend, email, subject, html_content)


def send_reset_password_email(email: str, token: str, background_tasks: BackgroundTasks):
    """Sends a password reset email to the user (via background task)."""
    reset_url = f"{settings.FRONTEND_URL}/reset-password?token={token}"
    subject = "Reset Your The Last Deploy Password"
    
    body_html = f"""
    <h2 style="margin-top: 0; margin-bottom: 16px; font-size: 22px; font-weight: 700; color: #0f172a; line-height: 1.3;">Password Reset Request</h2>
    <p style="margin: 0 0 24px 0; font-size: 15px; line-height: 1.6; color: #475569;">
        You recently requested to reset your password for your The Last Deploy account. Click the button below to choose a new one:
    </p>
    <p style="margin: 0 0 24px 0; text-align: center;">
        <a href="{reset_url}" style="display: inline-block; background-color: #10b981; color: #ffffff; padding: 12px 28px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 15px; box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);">
            Reset Password
        </a>
    </p>
    <p style="margin: 0 0 12px 0; font-size: 14px; color: #e11d48; font-weight: 500;">
        ⚠️ Note: This link will expire in 15 minutes.
    </p>
    <p style="margin: 0 0 8px 0; font-size: 13px; color: #64748b;">
        If you did not request this, you can safely ignore this email.
    </p>
    <p style="margin: 0 0 8px 0; font-size: 13px; color: #64748b;">
        If the button above does not work, copy and paste this link into your browser:
    </p>
    <p style="margin: 0 0 24px 0; font-size: 13px; word-break: break-all;">
        <a href="{reset_url}" style="color: #10b981; text-decoration: underline;">{reset_url}</a>
    </p>
    <p style="margin: 0; font-size: 15px; color: #475569; line-height: 1.6;">
        Thanks,<br>
        <strong>The Last Deploy Team</strong>
    </p>
    """
    
    html_content = _wrap_email_template(subject, body_html)

    if settings.ENVIRONMENT == "development":
        _log_email_to_console(email, subject, html_content)

    if settings.RESEND_API_KEY:
        background_tasks.add_task(send_email_via_resend, email, subject, html_content)
