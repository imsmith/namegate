# Requirements Traceability Matrix (RTM v1.0)

| **MRD Section**                     | **Market Requirement**                                          | **PRD ID(s)**                   | **Verification Method**                                                     | **Status / Priority** |
| ----------------------------------- | --------------------------------------------------------------- | ------------------------------- | --------------------------------------------------------------------------- | --------------------- |
| **5. Product Capabilities**         | Secure DNS Resolution (DNSSEC, DoT, DoH)                        | R-1, R-2, R-3                   | Unit + Integration test suites for RFC compliance, DNSSEC validation tests  | Must                  |
|                                     | Intelligent Caching (TTL, stale, outage)                        | C-1, C-2, C-3, C-4, C-5         | TTL expiry simulation, outage scenario test, performance profiling          | Must                  |
|                                     | Domain Trust Intelligence (CAA/TLSA tracking, cert observation) | S-1, S-2, S-3, S-4, S-5         | Functional tests with known misissued certs and mismatched CAA/TLSA records | Must                  |
|                                     | Policy Enforcement Engine (contextual DSL)                      | P-1, P-2, P-3, P-4, P-5         | Parser tests, rule evaluation benchmarks, policy acceptance tests           | Must                  |
|                                     | Firewall/EDR Integration (event emission)                       | O-2                             | Kafka/NATS event consumer test; schema validation and latency measurement   | Must                  |
|                                     | Federation & Scale-Out                                          | F-1, F-2, F-3, F-4              | Cluster simulation tests; Raft consensus and gossip convergence validation  | Should                |
|                                     | Resilience / Outage Handling                                    | C-3, C-4, C-5                   | Outage simulation; continuity benchmarks under loss of upstream             | Must                  |
|                                     | Observability & Metrics                                         | O-1, O-5                        | Prometheus endpoint check; telemetry metrics coverage test                  | Must                  |
|                                     | Administrative APIs                                             | O-3, O-4                        | API integration tests for CRUD, idempotency, and ACLs                       | Should                |
|                                     | Standards Compliance                                            | R-1, R-3                        | RFC compliance tests (1035, 2308, 4033–4035, 6698, 8659, 8767)              | Must                  |
| **2.4 Prosumer / Residential Edge** | Lightweight deployment, small footprint                         | H-5                             | Performance profiling on Raspberry Pi / ARM64 systems                       | Must                  |
|                                     | Local UI / Dashboard                                            | H-1                             | Functional and UX tests; user acceptance feedback                           | Should                |
|                                     | Privacy Baselines (telemetry/trackers)                          | P-5, H-4                        | Policy test lists; DNS traffic capture analysis                             | Should                |
|                                     | Device identification (DHCP/mDNS)                               | H-2                             | Local LAN testbed; MAC/IP mapping validation                                | Should                |
|                                     | Integration (pfSense, Home Assistant)                           | H-3                             | Plugin or export/import test with supported platforms                       | Could                 |
|                                     | Offline operation (cache persistence)                           | C-2, H-4                        | Simulated WAN outage test                                                   | Must                  |
| **6. Differentiation**              | Trust correlation (CAA/TLSA → cert)                             | S-1, S-2, S-4                   | Cross-verification test using test certificates                             | Must                  |
|                                     | Active revalidation, serve-stale                                | C-3, C-4                        | TTL expiry simulation with upstream timeout                                 | Must                  |
|                                     | Real-time SIEM/API export                                       | O-2, O-3                        | Latency and delivery accuracy benchmarks                                    | Should                |
| **7. Competitive Landscape**        | Federation & scale vs. legacy resolvers                         | F-1, F-2, F-3                   | Multi-node load test; throughput scaling validation                         | Should                |
| **9. Buyer Personas**               | Security operations need for integration                        | O-2, O-3                        | Integration demo validation with firewall/SIEM                              | Must                  |
|                                     | Prosumer need for control and visibility                        | H-1, H-4                        | Web UI usability and policy transparency tests                              | Should                |
| **10. Business Model**              | Open core model (community + enterprise features)               | Documentation deliverable       | Licensing review, packaging verification                                    | Informational         |
| **11. Success Metrics**             | ≥10k QPS per node @ <10ms p99                                   | Nonfunctional (Performance)     | Load testing, dnsperf benchmark                                             | Must                  |
|                                     | ≥85% cache hit ratio                                            | Nonfunctional (Performance)     | Long-duration traffic simulation                                            | Must                  |
|                                     | 24h+ outage continuity                                          | C-4, Nonfunctional (Resilience) | Controlled outage test                                                      | Must                  |
|                                     | <50 µs policy evaluation                                        | P-1                             | Microbenchmark, telemetry histogram                                         | Must                  |
|                                     | ≥3 integrations within 12 months                                | O-2, O-3                        | Partner validation                                                          | Should                |
|                                     | ≥1k prosumer installs                                           | H-1–H-5                         | Distribution analytics                                                      | Should                |
| **13. Roadmap Themes**              | Foundational trust core                                         | R-, S-, P- sets                 | Alpha test plan                                                             | Must                  |
|                                     | Outage continuity                                               | C-, O-, F- sets                 | Beta test plan                                                              | Must                  |
|                                     | Federation & scale-out                                          | F- sets                         | RC test plan                                                                | Should                |
|                                     | Integration & observability                                     | O- sets                         | RC test plan                                                                | Must                  |
|                                     | Home-lab readiness                                              | H- sets                         | GA test plan                                                                | Must                  |

---

## Verification Legend

| Method                           | Description                                                 |
| -------------------------------- | ----------------------------------------------------------- |
| **Unit Test**                    | Automated tests validating module-level logic.              |
| **Integration Test**             | Multi-component functional verification.                    |
| **Benchmark / Performance Test** | Measured latency, throughput, and resource metrics.         |
| **Simulation Test**              | Controlled outage, network failure, or federation scenario. |
| **User Acceptance Test (UAT)**   | Human testing of UI and workflow.                           |
| **Compliance Suite**             | RFC standard conformance checks.                            |
| **Manual Review**                | Documentation, licensing, or packaging inspection.          |

---

## Trace Summary

| MRD Area                         | Coverage    | Verification Confidence                          |
| -------------------------------- | ----------- | ------------------------------------------------ |
| Enterprise & MSSP requirements   | 100% mapped | High                                             |
| Prosumer / Home-lab requirements | 95% mapped  | High                                             |
| Federation / Scale-out           | 100% mapped | Medium (pending Raft prototype)                  |
| Policy DSL                       | 100% mapped | High                                             |
| Resilience / Serve-stale         | 100% mapped | High                                             |
| Observability / Integration      | 100% mapped | High                                             |
| UI / Ease-of-use                 | 80% mapped  | Medium (first release functional, later refined) |

---

## Notes

* Each PRD requirement will include a **test reference ID** in the QA test plan linking directly to its verification script or scenario.
* The RTM will be versioned alongside the PRD to maintain continuous compliance as features ship.
* The **QA sign-off** for GA requires all “Must” items verified and >90% of “Should” items passing.

---

Would you like me to build the **QA Verification Plan** next — listing the specific tests, tools (e.g., `dnsperf`, `dig`, ExUnit cases), and success criteria for each PRD item to operationalize this RTM? That document forms the bridge from traceability to implementation.
