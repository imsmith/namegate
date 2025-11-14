# Product Requirements Document (PRD v1.0)

**Product:** LDNS Sentinel
**Scope:** Secure Local DNS Infrastructure Platform for enterprise, MSSP, and prosumer/home-edge use

---

## 1. Purpose

Define the functional, performance, and quality requirements for LDNS Sentinel v1.x — the first fully integrated local DNS resolver and trust policy engine that validates DNS and TLS provenance, enforces policy, provides continuity during outages, and integrates with firewall and analytics systems.

---

## 2. Scope and Objectives

### 2.1 In Scope

* Full recursive resolver with DNSSEC validation.
* CAA, TLSA, and SOA tracking for provenance assurance.
* Policy engine (rule-based DSL) for contextual DNS control.
* Multi-tier caching with “serve-stale” and “serve-outage”.
* Certificate observation and judgment framework.
* Federation across peers (policy Raft, cache gossip).
* Observability and external integrations.
* Web UI (prosumer) and gRPC/CLI (enterprise) management interfaces.

### 2.2 Out of Scope (for initial release)

* GUI-based policy builder for enterprise (CLI and DSL suffice).
* Built-in threat intelligence correlation (manual import only).
* Advanced analytics dashboards (export metrics instead).
* QUIC probing and HTTP/3 support (future milestone).
* Full upstream authoritative behavior (stays as recursive resolver).

---

## 3. Product Overview

**Primary goals:**

* Deliver authenticated, policy-governed DNS/TLS resolution.
* Maintain local network operation during outages.
* Provide verifiable trust information to enforcement systems.
* Enable both enterprise-scale deployment and self-hosted home-lab use.

---

## 4. Functional Requirements

### 4.1 Resolver Core

| ID  | Requirement                                                                           | Priority | Acceptance Criteria                                                              |
| --- | ------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------- |
| R-1 | Implements recursive resolution for A, AAAA, CNAME, MX, TXT, NS, SRV, SOA, TLSA, CAA. | Must     | Resolves all common types; passes DNS compliance suite; 100% RFC 1035 compliant. |
| R-2 | Supports UDP/TCP/DoT/DoH listeners.                                                   | Must     | Queries accepted and answered via all transports; TLS termination optional.      |
| R-3 | Supports EDNS0, TCP fallback, and DNSSEC validation.                                  | Must     | DNSSEC validation per RFC 4033–4035; AD bit correct.                             |
| R-4 | Provides query minimization to upstream.                                              | Should   | Verified via qname-min test suite.                                               |
| R-5 | Supports ECS (client subnet) toggle by policy.                                        | Could    | Configurable per policy rule.                                                    |

### 4.2 Caching and Continuity

| ID  | Requirement                                                     | Priority | Acceptance Criteria                                                                          |                |
| --- | --------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------- | -------------- |
| C-1 | In-memory cache with TTL and negative cache per RFC 2308.       | Must     | Verified TTL behavior and negative caching via integration tests.                            |                |
| C-2 | Persistent cache for warm restart (RocksDB or ETS snapshot).    | Must     | Restart test: cached answers survive process restart.                                        |                |
| C-3 | Serve-stale mode for expired entries while refresh in progress. | Must     | Stale answers returned until upstream validated.                                             |                |
| C-4 | Outage detection via SOA tracking and probe failures.           | Must     | Outage detection triggered after 3 failed probes or static serial; stale-outage mode active. |                |
| C-5 | Administrator override for outage scope.                        | Should   | API command `set_outage(scope, force                                                         | clear)` works. |

### 4.3 Safety and Provenance Tracking

| ID  | Requirement                                                                   | Priority | Acceptance Criteria                                                          |
| --- | ----------------------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------- |
| S-1 | Fetch and parse CAA records; verify issuer matches certificates.              | Must     | CAA violation detected and flagged in event stream.                          |
| S-2 | Parse and validate TLSA records per RFC 6698.                                 | Must     | TLSA match computed correctly; results cached.                               |
| S-3 | Observe TLS certificates (TCP:443, 853); compute SPKI hash, issuer, validity. | Must     | 95% success rate in certificate capture; JSON event includes correct fields. |
| S-4 | Correlate certificate issuer with CAA and TLSA validity.                      | Must     | Event includes `caa_ok` and `tlsa_match` booleans.                           |
| S-5 | Detect SOA serial stagnation; flag outages.                                   | Should   | Outage raised when serial unchanged across refresh windows.                  |

### 4.4 Policy Engine

| ID  | Requirement                                                                                          | Priority | Acceptance Criteria                                                      |
| --- | ---------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------ |
| P-1 | DSL-based rule engine (NimbleParsec) supporting `allow`, `block`, `sinkhole`, `rewrite`, `annotate`. | Must     | Parser passes full syntax suite; evaluation latency <50 µs avg.          |
| P-2 | Contextual evaluation (qname, qtype, time, device, safety, reputation).                              | Must     | Rules can match all contexts and apply correct actions.                  |
| P-3 | Policy bundles versioned via Raft cluster (ra library).                                              | Should   | Policy update visible on all peers within 2 s; consistent hash verified. |
| P-4 | Policy enforcement applied both pre-resolution and post-safety.                                      | Must     | Verified through test queries with expected block/allow results.         |
| P-5 | Include built-in “privacy baseline” blocklist (trackers, telemetry).                                 | Should   | Default configuration blocks at least 90% of major ad/analytics domains. |

### 4.5 Federation and Scale-Out

| ID  | Requirement                                              | Priority | Acceptance Criteria                                                               |
| --- | -------------------------------------------------------- | -------- | --------------------------------------------------------------------------------- |
| F-1 | Cluster membership discovery via libcluster or Partisan. | Must     | Peers auto-discover via mDNS or static config.                                    |
| F-2 | Policy synchronization via Raft consensus.               | Must     | Policy changes atomic across peers; logs consistent.                              |
| F-3 | Cache gossip for hot key propagation.                    | Should   | Cache hit on cold peer after gossip exchange < 20 ms.                             |
| F-4 | Probe sharding via consistent hash ring.                 | Should   | Each domain assigned to exactly one probe owner; rebalanced on membership change. |

### 4.6 Observability and Integration

| ID  | Requirement                                                       | Priority | Acceptance Criteria                                               |
| --- | ----------------------------------------------------------------- | -------- | ----------------------------------------------------------------- |
| O-1 | Structured JSON logs; Telemetry + PromEx exporter.                | Must     | All queries logged with latency, action, DNSSEC status.           |
| O-2 | Kafka/NATS event emission for `dns.resolution` and `tls.observe`. | Must     | Event delivery success >99%; schema matches spec.                 |
| O-3 | gRPC Admin API for control plane.                                 | Should   | CRUD operations for policy, outage, and state queries pass tests. |
| O-4 | CLI tool for diagnostics (`ldnsctl`).                             | Should   | Commands: status, query, flush-cache, policy-apply.               |
| O-5 | Prometheus metrics (QPS, latency, cache hit ratio, outage count). | Must     | Exported metrics visible and scrapeable.                          |

### 4.7 Home-Lab / Prosumer Features

| ID  | Requirement                                           | Priority | Acceptance Criteria                                                |
| --- | ----------------------------------------------------- | -------- | ------------------------------------------------------------------ |
| H-1 | Web UI for visualization and policy editing.          | Should   | Responsive dashboard with device list, domain chart, cert issuers. |
| H-2 | Device identification via DHCP or mDNS.               | Should   | Device name and MAC linked to queries.                             |
| H-3 | Integration with pfSense/OPNsense and Home Assistant. | Could    | One-click configuration import/export.                             |
| H-4 | Privacy-first default configuration.                  | Must     | Default disables telemetry; DNSSEC and DoT enabled.                |
| H-5 | Minimal resource footprint.                           | Must     | <150 MB RAM idle, <10% CPU under 1k QPS.                           |

---

## 5. Nonfunctional Requirements

| Category          | Requirement                                                     | Metric                |
| ----------------- | --------------------------------------------------------------- | --------------------- |
| **Performance**   | Sustained ≥10k QPS per node, <10 ms p99 latency.                | Benchmark test suite. |
| **Availability**  | ≥99.99% service uptime (excluding admin shutdown).              | Reliability testing.  |
| **Scalability**   | Horizontal cluster scale to 100k QPS via federation.            | Load tests.           |
| **Security**      | All inter-peer and API traffic mTLS; DNSSEC validation default. | Pen test.             |
| **Privacy**       | No cloud dependency; optional telemetry opt-in only.            | Config verification.  |
| **Portability**   | Runs on Linux x86_64, ARM64; supports Docker and systemd.       | Build test.           |
| **Manageability** | Policy reload without restart; hot config updates.              | Functional test.      |
| **Resilience**    | Serve-stale and serve-outage guarantee continuity for 24h+.     | Integration test.     |

---

## 6. System Architecture Overview (Conceptual)

* **Core services:** Resolver, Cache, Safety tracker, Policy engine.
* **Storage:** ETS (hot), RocksDB (warm).
* **Communication:** NATS or Kafka bus for events; gRPC for control.
* **Federation:** Raft consensus for policy; gossip mesh for cache.
* **Probing subsystem:** Scheduled TLS probes; results feed Safety tracker.
* **Interfaces:** DNS (53/UDP,TCP), DoT(853), DoH(443), Web UI(8080), gRPC(8443).

---

## 7. Release Plan

| Phase          | Scope                                                                     | Key Deliverables         |
| -------------- | ------------------------------------------------------------------------- | ------------------------ |
| **Alpha (M1)** | Core resolver, cache, DNSSEC validation, serve-stale.                     | Running on one node.     |
| **Beta (M2)**  | CAA/TLSA tracking, safety judgments, basic policy engine, web UI (basic). | Local trust enforcement. |
| **RC (M3)**    | Outage detection, event bus, gRPC API, federation (Raft + gossip).        | Clustered operation.     |
| **GA (M4)**    | Full policy DSL, integrations (pfSense, Home Assistant), telemetry.       | Public release.          |

---

## 8. Success Metrics

| Category              | Target                                                              |
| --------------------- | ------------------------------------------------------------------- |
| Functional compliance | 100% MRD requirements met.                                          |
| Performance           | 10k QPS node throughput, p99 <10 ms.                                |
| Stability             | Mean uptime >30 days continuous.                                    |
| Adoption              | ≥3 enterprise pilots, ≥1k prosumer installations within 6 months.   |
| Integration           | 3 partner integrations (firewall/SIEM).                             |
| Community             | ≥100 GitHub stars + 50 open-source contributors by end of year one. |

---

## 9. Open Questions / TBD

1. Reputation data source for policy (public feeds or internal scoring?).
2. Default CAA/TLSA probing frequency and backoff policy.
3. Licensing structure: AGPLv3 core vs dual-license commercial.
4. Level of UI functionality before 1.0 (read-only vs editable policies).
5. Whether to implement full DNS-over-QUIC in v1.x or postpone.

---

## 10. Approval and Ownership

| Role            | Name | Responsibility                            |
| --------------- | ---- | ----------------------------------------- |
| Product Owner   | TBD  | Overall feature scope and prioritization  |
| Technical Lead  | TBD  | Architecture and code review              |
| QA Lead         | TBD  | Test suite design                         |
| Security Lead   | TBD  | Validation of mTLS, DNSSEC, safety checks |
| Release Manager | TBD  | Deployment and versioning                 |

