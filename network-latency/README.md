# Network Latency

As a non-chaotic example, here is how we could assess network latencies between different continents at different times of day in order to determine if there is a time component, as has increasingly been anecdotally reported with increased bandwidth usage during the present lockdowns. Essentially this allows us to assign edge weights to a graph of network connectivity, where the weight corresponds to latency.

We measured latencies from five continents around the world to IP addresses in six continents. We choose IP addresses that are specifically not using CDNs (Content Delivery Network) to ensure that the servers are actually located in their respective countries. We also ensure that the websites are not hosted by Google by checking for forwards to URLs that contain domain names like “googleusercontent.com”. By doing these checks we can try to avoid the possibility that Google might have all their servers connected by high speed interfaces or have CDNs built-in. The latencies are measured once every five hours to let us understand its variation throughout the day in different countries.

To ensure that for every continent we picked a local business in a major city that has a low chance of having CDNs, we picked local bakeries. Most bakeries don’t have a website but the ones that do are used for local deliveries, online orders, or just for having an online presence. Using the “ping” command, we extracted the IP addresses from the bakery websites. “Ping” also tells us about where the website is hosted. For example, googleusercontent.com, akamaitechnologies.com, amazonaws.com, etc. tells us that a site is hosted on cloud services or CDNs, whereas zen.co.uk is a local ISP. 

We use Google Kubernetes Engine (GKE) and Google Cloud APIs to create a kubernetes cluster and deploy our app to the pods. The cluster creation process uses the tooling we previously developed that entails a deployment file to be deployed.

The starter script is a bash script that creates a cluster of desired number of nodes, at the desired geographic zone. The starter script also takes as argument the deployment file, which is a json file that describes what docker container should be run in the corresponding cluster and what command should the docker container run. One can also specify ports that should be opened if needed. This json is passed on to our Go program that actually does the deployment using GKE’s kubernetes API.

Experiment:
We recorded latencies to each of the IP addresses in the UK (Europe), US (North America), Argentina (South America), South Africa (Africa), New Zealand (Australia), and India (Asia) from GKE pods in the UK, Argentina, US, Australia, and India. GKE is not currently available in any of the countries in Africa so our tool does not support that region.


From Fig.1 we can see that the latencies do not change significantly for each GKE location throughout the day. The US has the lowest latencies overall at all times and Indian servers have the most latency overall.


Fig. 1: All latencies



Fig. 2a shows that there are latency peaks at 9AM and 9PM PST from US servers to US IP addresses, perhaps indicative of the start of the workday and evening / night entertainment streaming. Latencies remain the same throughout the day for US servers to Indian IP (Fig. 2b). At 9PM PST, which is 9:30 PM IST, we see a peak latency from the Indian server to Indian IP (Fig. 2c).



Fig. 2: Latencies at all times from a) US server to US IP b) US server to Indian IP c) Indian server to Indian IP


Fig. 3 illustrates the latencies from the US server to all IP addresses at all times. We see that there is not much variance in latencies throughout the day.

Fig. 3: Latency from US server to all locations at all times


	These analyses not only provide insight on the diurnal rhythms of network timings across the worldwide internet, and also demonstrate how easily we can measure them with the tool for deploying and executing commands across geographic zones.


## How To Run

1. Run `./launch-all.sh`
2. Run `./extract_latency.sh`

This will print all latencies on your shell
