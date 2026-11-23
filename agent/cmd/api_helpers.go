// agent/cmd/api_helpers.go
package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

// postJSONRequest sends a JSON POST request to the API with authorization headers and timeout.
// It returns error, shouldRetry boolean, and decoded response JSON body map if available.
func postJSONRequest(apiBaseURL, endpoint, authToken string, payload interface{}, timeout time.Duration, orgSlug ...string) (error, bool, map[string]interface{}) {
	data, err := json.MarshalIndent(payload, "", "  ")
	if err != nil {
		return err, false, nil
	}

	client := &http.Client{Timeout: timeout}
	req, err := http.NewRequest(http.MethodPost, apiBaseURL+endpoint, bytes.NewReader(data))
	if err != nil {
		return err, false, nil
	}

	req.Header.Set("Content-Type", "application/json")
	if authToken != "" {
		req.Header.Set("Authorization", "Bearer "+authToken)
	}
	if len(orgSlug) > 0 && orgSlug[0] != "" {
		req.Header.Set("X-Organization-Slug", orgSlug[0])
		req.Header.Set("X-Organization", orgSlug[0])
	}

	resp, err := client.Do(req)
	if err != nil {
		return err, true, nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		body, _ := io.ReadAll(resp.Body)
		retry := resp.StatusCode >= 500 || resp.StatusCode == http.StatusRequestTimeout || resp.StatusCode == http.StatusTooManyRequests
		return fmt.Errorf("API returned %d: %s", resp.StatusCode, strings.TrimSpace(string(body))), retry, nil
	}

	var respBody map[string]interface{}
	_ = json.NewDecoder(resp.Body).Decode(&respBody)

	return nil, false, respBody
}

// getJSONRequest sends a GET request with authorization and optional organization headers.
func getJSONRequest(apiBaseURL, endpoint, authToken string, timeout time.Duration, orgSlug ...string) (error, int, []byte) {
	client := &http.Client{Timeout: timeout}
	req, err := http.NewRequest(http.MethodGet, apiBaseURL+endpoint, nil)
	if err != nil {
		return err, 0, nil
	}

	req.Header.Set("Content-Type", "application/json")
	if authToken != "" {
		req.Header.Set("Authorization", "Bearer "+authToken)
	}
	if len(orgSlug) > 0 && orgSlug[0] != "" {
		req.Header.Set("X-Organization-Slug", orgSlug[0])
		req.Header.Set("X-Organization", orgSlug[0])
	}

	resp, err := client.Do(req)
	if err != nil {
		return err, 0, nil
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return err, resp.StatusCode, nil
	}

	return nil, resp.StatusCode, body
}
