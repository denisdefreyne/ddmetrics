## Roadmap

This document details the changes need to get to a stable 1.0.

*   **Don’t use the term “telemetry”:** The term “telemetry” specifically refers to collecting data from remote systems. DDTelemetry does not at all collect from remote systems (in fact, that is explicitly out-of-scope). Suggestion: DDMetrics?

*   **Key-value labels:** Labels can currently be any object. Stabilising on key-value labels, with keys being symbols and labels being strings, would make it easier to create tooling around transforming and analysing datasets that are produced by DDTelemetry.

*   **Force data types:** Counter values must be natural numbers, and summary values must be real numbers.

*   **Describe public API:** The API that described in the README is not powerful enough for real-world use cases. Specifically, there need to be methods for extracting recorded data:

    * Extracting data from a counter:
        * `LabelledCounter#get(label)` &rarr; `Counter`
        * `Counter#value` &rarr; `Integer`
    * Extracting data from a summary:
        * `LabelledSummary#get(label)` &rarr; `Summary`
        * `Summary#to_a` &rarr; (sorted) `Array` of `Numeric`

    DDTelemetry could also publicly offer functionality for doing statistical calculations, e.g. `min`, `max`, `average`, `variance`, `stddev`, `sum`, `count`, `percentile(…)`, `median`, `mode`, …. Alternatively, DDTelemetry might defer to an external library such as [descriptive-statistics](https://github.com/jtescher/descriptive-statistics).
