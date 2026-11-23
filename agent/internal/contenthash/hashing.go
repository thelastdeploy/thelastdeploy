package contenthash

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sort"
)

// ComputeFilesHash computes a deterministic SHA-256 hash across a map of {filename: content}.
// Filenames are processed in alphabetical order.
// Newlines (CRLF) are normalized to LF (\n).
func ComputeFilesHash(files map[string][]byte) string {
	keys := make([]string, 0, len(files))
	for k := range files {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	hasher := sha256.New()
	for _, filename := range keys {
		val := files[filename]
		if val == nil {
			continue
		}
		normalized := bytes.ReplaceAll(val, []byte("\r\n"), []byte("\n"))
		header := fmt.Sprintf("%s:%d:", filename, len(normalized))
		hasher.Write([]byte(header))
		hasher.Write(normalized)
		hasher.Write([]byte("\n"))
	}

	return hex.EncodeToString(hasher.Sum(nil))
}

// ComputeModuleHash calculates independent hash for a module using only module.yaml.
func ComputeModuleHash(moduleYAML []byte) string {
	return ComputeFilesHash(map[string][]byte{
		"module.yaml": moduleYAML,
	})
}

// ComputeSectionHash calculates independent hash for a section using section.yaml and content.md.
func ComputeSectionHash(sectionYAML []byte, contentMD []byte) string {
	files := map[string][]byte{
		"section.yaml": sectionYAML,
	}
	if contentMD != nil {
		files["content.md"] = contentMD
	}
	return ComputeFilesHash(files)
}

// ComputeLabHash calculates independent hash for a lab using lab.yaml, cleanup.sh, and validator.sh (or validator.py).
func ComputeLabHash(labYAML []byte, cleanupSH []byte, validatorScript []byte, isPythonValidator bool) string {
	files := map[string][]byte{
		"lab.yaml": labYAML,
	}
	if cleanupSH != nil {
		files["cleanup.sh"] = cleanupSH
	}
	if validatorScript != nil {
		if isPythonValidator {
			files["validator.py"] = validatorScript
		} else {
			files["validator.sh"] = validatorScript
		}
	}
	return ComputeFilesHash(files)
}
