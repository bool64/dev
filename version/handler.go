package version

import (
	"encoding/json"
	"net/http"
)

// Handler serves version information with HTTP.
func Handler(w http.ResponseWriter, _ *http.Request) {
	b, err := json.Marshal(Info())
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	w.Header().Set("Content-Type", "application/json")
	_, _ = w.Write(b)
}
