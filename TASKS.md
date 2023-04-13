# SRE challenge

## Issue 1

### Understanding the traffic

I'd start with checking logs to make sure traffic is legitimate and not a DDoS
attack. In order to determine if it's a DDoS attack, I'd check:

* **Endpoints**: requests are coming. If all the requests are coming to a
    certain endpoint that would be indication of a DDoS attack.
* **Source IPs**: If the sources IPs are same or from one region/range or from
    same AS (autonomous system) that would be another indication of a DDoS
    attack.
* **Device**: I'd check the device by looking at User Agent string of the
    requests. This is a long shoot but I'd make sure user agents are legit
    browser user agents.


### Actions to take if it's a DDoS attack

* If the attack is coming from a single IP address or range I'd start by
  immediately creating a  **Network Policy** to block these IPs for
  HAProxy Ingress Controller.
* If it's coming to a certain endpoint I'd add **Rate Limiting** to these
  endpoints by editing Ingress resource or by globally editing kubernetes-ingress
  ConfigMap.
* Adding more nodes and scaling pods accordingly will help reducing the load.


### Suggestions

* Global rate limiting Ingress controller can mitigate most of the attacks.
* Using a WAF or third party DDoS protection tool
    (AWS Cloudfront or Cloudflare) is very useful but expensive.


### Automated solutions

* Kubernetes **HorizontalPodAutoscaler** can add/remove nodes and scale pods
    accordingly on demand.
* Collecting metrics with Prometheus and creating alerts for this kind of traffic
    surges will help to identify and solve issue in a manner of time.


# Issue 2

As a SRE, my job is to make sure all services are running. I'd start with
trying to reproduce the issue and make sure backup micro-services are working
by checking logs. If it's a server related issue, I would take action
immediately to solve problem, and bring back services to healthy state.

If it's a software issue I'd create a ticket with **critical** severity, since
clients are getting affected directly by this important feature, and provide
logs in my ticket to help developers to understand issue.
