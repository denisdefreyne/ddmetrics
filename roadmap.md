## Roadmap

This document details the changes need to get to a stable 1.0.

*   **Don’t use the term “telemetry”:** The term “telemetry” specifically refers to collecting data from remote systems. DDTelemetry does not at all collect from remote systems (in fact, that is explicitly out-of-scope). Suggestion: DDMetrics?

*   **Key-value labels:** Labels can currently be any object. Stabilising on key-value labels, with keys being symbols and labels being strings, would make it easier to create tooling around transforming and analysing datasets that are produced by DDTelemetry.
