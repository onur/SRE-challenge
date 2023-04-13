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

## Step 1: Evaluation of the severity of the incident

The first step in handling the incident is to assess its severity. Since the
backup creation feature in the dashboard app is not working, it can lead to
data loss and affect the customer's ability to access their data. Therefore,
this incident is considered a high-priority incident that requires immediate
attention.

## Step 2: Incident handling and escalation process

The incident handling and escalation process should be followed to ensure that
the incident is resolved as quickly as possible. Here is the process that I
would follow:

1. Gather information: I would ask the first line of customer support to
    provide me with more information about the incident, such as the error
    message received by the customer, the impact of the incident on the customer,
    and any troubleshooting steps they have taken so far.
2. Escalation: Depending on the severity of the incident, I would escalate it
    to the appropriate level. Since this is a high-priority incident, I would
    escalate it to the second line of support, who have more expertise and
    experience with the dashboard app.
3. Investigation: The second line of support would investigate the issue
    further by reviewing the logs, error messages, and any other relevant
    information to identify the root cause of the issue.
4. Communication: Throughout the process, it is important to keep the customer
    informed about the status of the incident. I would provide regular updates
    to the customer via email or phone to let them know that the incident is being
    investigated and that we are working on a resolution.
5. Resolution: Once the root cause of the issue is identified, the second line
    of support would work on resolving the issue. If necessary, they would work
    with the development team to develop a fix for the issue.
6. Testing: Once the issue has been resolved, the second line of support would
    test the backup creation feature to ensure that it is working as expected.
7. Follow-up: After the incident has been resolved, I would follow up with the
    customer to ensure that they are satisfied with the resolution and that the
    backup creation feature is working as expected.

Overall, the incident handling and escalation process should be followed
carefully to ensure that the incident is resolved quickly and effectively, and
the customer is satisfied with the outcome.
