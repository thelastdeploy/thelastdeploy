# web/backend/app/hashing.py — deterministic independent content hashing
import hashlib


def compute_files_hash(files: dict[str, bytes | str | None]) -> str:
    """
    Computes a deterministic SHA-256 hash across a dictionary of {filename: content}.
    Filenames are processed in alphabetical order.
    Newlines (CRLF) are normalized to LF (\\n).
    Missing or None files are excluded.
    """
    hasher = hashlib.sha256()
    for filename in sorted(files.keys()):
        raw_val = files[filename]
        if raw_val is None:
            continue
        if isinstance(raw_val, str):
            val_bytes = raw_val.encode("utf-8")
        else:
            val_bytes = raw_val

        # Normalize CRLF -> LF
        normalized = val_bytes.replace(b"\r\n", b"\n")
        header = f"{filename}:{len(normalized)}:".encode("utf-8")
        hasher.update(header)
        hasher.update(normalized)
        hasher.update(b"\n")
    return hasher.hexdigest()


def compute_module_hash(module_yaml: bytes | str) -> str:
    """Calculates independent hash for a module using only module.yaml."""
    return compute_files_hash({"module.yaml": module_yaml})


def compute_section_hash(section_yaml: bytes | str, content_md: bytes | str | None = None) -> str:
    """Calculates independent hash for a section using only section.yaml and content.md."""
    files = {"section.yaml": section_yaml}
    if content_md is not None:
        files["content.md"] = content_md
    return compute_files_hash(files)


def compute_lab_hash(
    lab_yaml: bytes | str,
    cleanup_sh: bytes | str | None = None,
    validator_sh: bytes | str | None = None,
    validator_py: bytes | str | None = None,
) -> str:
    """Calculates independent hash for a lab using only lab.yaml, cleanup.sh, and validator.sh (or validator.py)."""
    files: dict[str, bytes | str | None] = {"lab.yaml": lab_yaml}
    if cleanup_sh is not None:
        files["cleanup.sh"] = cleanup_sh
    if validator_sh is not None:
        files["validator.sh"] = validator_sh
    elif validator_py is not None:
        files["validator.py"] = validator_py
    return compute_files_hash(files)

