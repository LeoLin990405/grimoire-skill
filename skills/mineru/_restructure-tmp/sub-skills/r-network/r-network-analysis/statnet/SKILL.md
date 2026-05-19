---
name: statnet
description: R statnet suite for network analysis. Use for statistical modeling of network data including ERGM.
---

# statnet

Statistical analysis of network data.

## Installation

```r
# Install statnet suite
install.packages("statnet")

# Load
library(statnet)
# Loads: network, sna, ergm, tergm, networkDynamic, etc.
```

## Network Descriptives (sna)

```r
library(sna)

# Centrality measures
degree(net)
degree(net, cmode = "indegree")
degree(net, cmode = "outdegree")

betweenness(net)
closeness(net)
evcent(net)  # Eigenvector centrality

# Network-level measures
gden(net)      # Density
grecip(net)    # Reciprocity
gtrans(net)    # Transitivity
centralization(net, degree)
```

## ERGM (Exponential Random Graph Models)

```r
library(ergm)

# Fit basic ERGM
fit <- ergm(net ~ edges)

# With structural terms
fit <- ergm(net ~ edges + mutual + triangle)

# With node attributes
fit <- ergm(net ~ edges + nodematch("gender") + nodecov("age"))

# With edge attributes
fit <- ergm(net ~ edges + edgecov(covariate_matrix))

# Summary
summary(fit)
```

## ERGM Terms

```r
# Structural terms
edges           # Number of edges
mutual          # Mutual ties (reciprocity)
triangle        # Triangles
gwesp(0.5)      # Geometrically weighted ESP
gwdegree(0.5)   # Geometrically weighted degree
kstar(2)        # 2-stars

# Attribute terms
nodematch("attr")      # Homophily
nodemix("attr")        # Mixing patterns
nodecov("attr")        # Node covariate (continuous)
nodefactor("attr")     # Node factor (categorical)
absdiff("attr")        # Absolute difference

# Dyadic terms
edgecov(matrix)        # Edge covariate
```

## ERGM Diagnostics

```r
# MCMC diagnostics
mcmc.diagnostics(fit)

# Goodness of fit
gof_result <- gof(fit)
plot(gof_result)

# Simulate from model
sim_nets <- simulate(fit, nsim = 100)
```

## TERGM (Temporal ERGM)

```r
library(tergm)

# Create network list
net_list <- list(net_t1, net_t2, net_t3)

# Fit STERGM (separable temporal ERGM)
fit <- stergm(
  net_list,
  formation = ~ edges + mutual,
  dissolution = ~ edges,
  estimate = "CMLE"
)

# Summary
summary(fit)
```

## Network Visualization (sna)

```r
# Basic plot
gplot(net)

# With attributes
gplot(net,
      vertex.col = net %v% "color",
      vertex.cex = degree(net) / max(degree(net)) * 3,
      edge.col = "gray",
      displaylabels = TRUE
)

# Layout algorithms
gplot(net, mode = "fruchtermanreingold")
gplot(net, mode = "kamadakawai")
gplot(net, mode = "circle")
gplot(net, mode = "mds")
```

## Community Detection

```r
# Equivalence clustering
eq <- equiv.clust(net)
plot(eq)

# Block modeling
bm <- blockmodel(net, eq, k = 3)
plot(bm)
```

## Network Comparison

```r
# QAP correlation
qap_result <- qaptest(list(net1, net2), gcor, g1 = 1, g2 = 2)
summary(qap_result)
plot(qap_result)

# Network correlation
gcor(net1, net2)

# Hamming distance
hdist(net1, net2)
```

## Simulation

```r
# Simulate from ERGM
sim <- simulate(fit, nsim = 100)

# Random graphs
rgraph(n = 10, m = 1, tprob = 0.3)  # Bernoulli
rgnm(n = 10, m = 20)                 # Fixed edges
```

## Latent Space Models

```r
library(latentnet)

# Fit latent space model
fit <- ergmm(net ~ euclidean(d = 2))

# With clustering
fit <- ergmm(net ~ euclidean(d = 2, G = 3))

# Plot
plot(fit)
```

## Network Regression

```r
# Network autocorrelation model
library(sna)

# QAP regression
netlm_result <- netlm(net, list(covariate1, covariate2), reps = 1000)
summary(netlm_result)

# Network logistic regression
netlogit_result <- netlogit(net, list(cov1, cov2), reps = 1000)
summary(netlogit_result)
```
