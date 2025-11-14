# Market Requirements Document (MRD v1.1)

## 1. Product Overview

**Product Name (working):** LDNS Sentinel
**Category:** Secure Local DNS Infrastructure Platform

**Purpose:**
LDNS Sentinel is a next-generation local DNS resolver and trust policy engine for enterprise, service-provider, and advanced consumer environments. It ensures that DNS, TLS, and certificate behaviors remain authentic and policy-compliant while providing deep visibility to security infrastructure and network administrators.

**Value Proposition:**
Unlike traditional resolvers that stop at resolving names, LDNS Sentinel resolves trust. It validates domain provenance (DNSSEC, CAA, TLSA), correlates that data with certificate observations, enforces local policy, and supplies real-time trust telemetry to firewalls and SIEM systems. It maintains service continuity during upstream outages and federates across peers to scale from a single homelab to large enterprise networks.

---

## 2. Target Market

### 2.1 Enterprise and Institutional Networks

* Enterprises (1k–100k endpoints) requiring DNS visibility, policy control, and verified certificate trust.
* Sectors: finance, healthcare, defense, critical infrastructure.
* Operated by security engineering or NetOps teams; compliance-focused (SOC2, FedRAMP, ISO27001).

### 2.2 Managed Security Service Providers (MSSPs)

* Providers offering DNS firewalling, threat intelligence, and policy-managed DNS resolution as a service.
* Require multi-tenant federation and strong observability.

### 2.3 Critical Infrastructure Operators

* Energy, transport, telecom, and utilities.
* Need high assurance, high resilience LDNS with continuous operation during WAN or upstream failures.

### 2.4 Home-Lab / Prosumer / Residential Edge

**Profile:**
Advanced users running homelabs, edge networks, and privacy-centric households with 10–200 devices (IoT, media, VMs).
**Pain Points:**

* Opaque IoT behavior and vendor DNS bypassing local resolvers.
* Lack of device-level control over DNS/TLS trust.
* Fragmented ad-blockers without validation or certificate awareness.
* Outages breaking smart-home functionality.

**Functional Implications:**

* Lightweight single-node deployment, minimal dependencies.
* Web UI for monitoring, visualization, and rule editing.
* Privacy-first defaults; built-in telemetry/analytics blocking.
* Per-device identification via DHCP or network discovery.
* Integrations with pfSense, OPNsense, Home Assistant, Pi-hole.
* Local resilience and safe offline mode.

---

## 3. Market Drivers

| Driver                             | Description                                                                                                 |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **TLS Certificate Abuse**          | Fraudulent or misissued certificates used for phishing, supply-chain attacks, and data exfiltration.        |
| **DNSSEC, CAA, TLSA Adoption**     | Growing use of DNS-based trust signals that most resolvers ignore.                                          |
| **Zero Trust Networking**          | DNS must participate in identity and trust policy enforcement.                                              |
| **Data Sovereignty & Privacy**     | Organizations and consumers alike want on-premises resolution and control, not outsourced DNS.              |
| **IoT Proliferation**              | Homes and enterprises alike face untrusted, telemetry-heavy devices phoning home globally.                  |
| **Resilience & Outage Continuity** | Service interruption due to upstream DNS failures is unacceptable in both enterprise and consumer contexts. |
| **Network Intelligence**           | Security systems need correlation between DNS queries, TLS sessions, and observed certificates.             |

---

## 4. Problem Statement

Legacy LDNS software (BIND, Unbound, dnsmasq, CoreDNS) was built for correctness, not trust enforcement.
They:

* Provide limited policy hooks.
* Ignore certificate provenance (CAA/TLSA).
* Don’t correlate DNS answers to observed certificates.
* Don’t share intelligence with security systems.
* Offer no “serve-stale” continuity during outages.
* Don’t federate state across large or distributed networks.

Meanwhile, the residential edge is becoming a battlefield of data collection, telemetry, and opaque connectivity. Users want privacy, transparency, and continuity — qualities LDNS Sentinel delivers.

---

## 5. Product Capabilities (Market-Level)

| Category                         | Requirement Summary                                                                                   | Priority |
| -------------------------------- | ----------------------------------------------------------------------------------------------------- | -------- |
| **Secure DNS Resolution**        | Full recursive resolver with DNSSEC, EDNS0, DoT, DoH support.                                         | Must     |
| **Intelligent Caching**          | Multi-tier cache with serve-stale and serve-outage behavior; background revalidation.                 | Must     |
| **Domain Trust Intelligence**    | Track SOA, CAA, TLSA, and certificates; detect mismatches and misissuance.                            | Must     |
| **Policy Enforcement Engine**    | Context-aware DSL for allow/block/rewrite/sinkhole based on time, user, device, reputation, or trust. | Must     |
| **Firewall/EDR Integration**     | Real-time DNS and TLS observation events for correlation and enforcement.                             | Must     |
| **Federation & Scale-Out**       | Peer clusters with Raft for policy and gossip for cache; multi-site consistency.                      | Should   |
| **Resilience / Outage Handling** | Continue to resolve using cached data during authoritative or upstream failures.                      | Must     |
| **Observability**                | Telemetry, tracing, structured logs, and metrics; export to Prometheus, Splunk, or Kafka.             | Must     |
| **Administrative APIs**          | gRPC/REST management; policy, blocklist, and outage control.                                          | Should   |
| **Standards Compliance**         | RFCs: 1035, 2308, 4033–4035, 6698, 6840, 8659, 8767.                                                  | Must     |
| **Consumer-Edge UI**             | Web dashboard showing device map, domain reputation, and certificate issuers.                         | Should   |
| **Privacy Presets**              | Built-in tracker and telemetry blocking policies.                                                     | Should   |
| **Device Awareness**             | Per-device policy enforcement and query logging.                                                      | Should   |
| **Offline Operation**            | Cache persistence; no dependency on cloud or upstream control plane.                                  | Must     |

---

## 6. Differentiation

| Dimension      | Traditional LDNS   | LDNS Sentinel                           |
| -------------- | ------------------ | --------------------------------------- |
| Security Focus | DNS integrity      | End-to-end trust validation (DNS + TLS) |
| Policy         | Static lists, ACLs | Dynamic, contextual rule engine         |
| Caching        | TTL-bound          | Active revalidation, outage continuity  |
| Integration    | Syslog, RPZ        | Real-time events, APIs, SIEM-ready      |
| Scale          | Standalone node    | Federated cluster                       |
| Visibility     | DNS only           | DNS + Certificate provenance            |
| Deployment     | Server-centric     | Edge-friendly and scalable              |

---

## 7. Competitive Landscape

| Competitor                                 | Strengths              | Weaknesses vs Sentinel                      |
| ------------------------------------------ | ---------------------- | ------------------------------------------- |
| **Unbound**                                | DNSSEC, reliability    | No policy or TLS awareness                  |
| **CoreDNS**                                | Plugin flexibility     | Weak validation, no provenance tracking     |
| **dnsdist / PowerDNS Recursor**            | Scalable, programmable | No cert correlation, no outage serve        |
| **Pi-hole**                                | Easy blocking, popular | No DNSSEC by default, no trust intelligence |
| **AdGuard Home**                           | User-friendly UI       | Weak validation, no policy depth            |
| **Cloud DNS firewalls (NextDNS, OpenDNS)** | Easy setup             | Cloud dependency, no local sovereignty      |
| **Commercial DNS firewalls**               | Reputation feeds       | Limited transparency, no TLSA/CAA awareness |

---

## 8. Market Size & Opportunity

* **Enterprise DNS security** market: ~$1.5B (2025), 12–15% CAGR.
* **Residential privacy/security** tools: ~$500M emerging submarket, driven by IoT privacy demand.
* **Critical infrastructure** DNS hardening: growing due to regulatory mandates (NIS2, CISA, DORA).
  → Combined accessible market estimate: **$2B+** within 3–5 years.

---

## 9. Buyer Personas

| Persona                                   | Needs                                      | Triggers                                   |
| ----------------------------------------- | ------------------------------------------ | ------------------------------------------ |
| **CISO / SecArch**                        | Verified trust chain, SIEM integration     | Certificate abuse or DNS spoofing incident |
| **NetOps / DNS Admin**                    | Unified caching, resilience, observability | Outage or DNS modernization project        |
| **MSSP Product Manager**                  | Scalable multi-tenant resolver platform    | Client compliance demand                   |
| **Compliance Lead**                       | Data sovereignty, DNSSEC mandates          | Audit readiness                            |
| **Prosumer / Homelab Enthusiast**         | Privacy, transparency, IoT control         | Smart-home data exposure concerns          |
| **Privacy Advocate / Open Hardware User** | DNS independence from big-tech             | Cloud DNS distrust                         |

---

## 10. Business & Pricing Model

**Model:** Open core with optional commercial features.

| Tier                            | Audience                    | Features                                   | Pricing             |
| ------------------------------- | --------------------------- | ------------------------------------------ | ------------------- |
| **Community (Free)**            | Prosumer / Homelab          | Core resolver, caching, DNSSEC, UI         | Free                |
| **Professional (Subscription)** | SMB / Enterprise            | Policy DSL, TLSA/CAA intelligence, metrics | $50–500 / yr / node |
| **Enterprise**                  | Large orgs / MSSPs          | Federation, SIEM integration, support      | Custom license      |
| **Managed SaaS**                | Remote policy orchestration | Cloud-hosted control, local resolvers      | Usage-based         |

---

## 11. Success Metrics

| Metric                    | Target                                                    |
| ------------------------- | --------------------------------------------------------- |
| Query throughput per node | ≥ 10k QPS, <10 ms p99                                     |
| Cache hit ratio           | >85%                                                      |
| Policy eval latency       | <50 µs                                                    |
| Outage continuity         | 24h+ without service loss                                 |
| Pilot adoption            | ≥3 enterprise and ≥1k prosumer installs in first 6 months |
| Integration               | 3 firewall/SIEM integrations by end of year one           |
| Reliability               | <1 crash per 10M queries                                  |
| Consumer rating           | >4.5/5 in OSS and prosumer communities                    |

---

## 12. Risks & Mitigation

| Risk                                                 | Mitigation                                                               |
| ---------------------------------------------------- | ------------------------------------------------------------------------ |
| **Perceived complexity**                             | Ship with safe defaults and guided UI                                    |
| **Competition from free filters (Pi-hole, AdGuard)** | Differentiate via provenance validation, resilience, and trust analytics |
| **Certificate correlation overhead**                 | Incremental rollout, cached results, optional probing                    |
| **Federation reliability**                           | Use tested Raft and gossip libraries; chaos testing                      |
| **Privacy scrutiny**                                 | No cloud dependency; optional anonymization                              |
| **Resource consumption on small hardware**           | Adaptive caching and concurrency controls                                |

---

## 13. Roadmap Themes

1. **Foundational Trust Core**

   * Recursive resolver, cache, DNSSEC, CAA/TLSA validation, policy engine.
2. **Outage Continuity & Serve-Stale**

   * TTL override logic, SOA tracking, outage state persistence.
3. **Federation & Scale-Out**

   * Raft-based policy sync, cache gossip, probe sharding.
4. **Firewall & SIEM Integration**

   * Kafka/NATS feeds, Prometheus exporter, OpenTelemetry tracing.
5. **Home-Lab & Edge Readiness**

   * Web UI, installer, integrations with pfSense/Home Assistant.
6. **Analytics & Reputation Engine**

   * Passive DNS, CA scoring, anomaly detection.

---

## 14. Strategic Positioning Statement

For enterprises, managed security providers, and advanced users who demand trustworthy and resilient name resolution, **LDNS Sentinel** is a **security-grade local DNS platform** that validates not only *what* domains resolve but *who* is authorized to serve them.

It bridges DNS, certificate validation, and policy control—federated when needed, local when required—bringing end-to-end trust enforcement from datacenters to home networks.

