# Spatial Clustering Detection for Data with Covariates and Excessive Zeros (`MS`)

An R package for identifying geographic spatial clusters and disease hotspots in zero-inflated spatial data with complex covariates using a mixture scan statistic approach.

## 📌 Background & Motivation

In the study of infectious diseases, cluster analysis is a useful statistical method to explore the relationship between disease hot spots and propagation patterns associated with risk factors. However, when covariates and excessive zeros also produce clustering effects for responses, traditional identification methods for geographic clusters may not address this confounding issue well.

Moreover, for complex surveillance systems, scrutinizing all risk factors that could simultaneously affect health outcomes and geographic clusters would be difficult, which could cause large spatial variations and thus create a convergency issue for the Bayesian algorithm.

To address these issues, a **mixture scan statistic** that is associated with two-part and cluster models is developed to identify geographic clusters for spatial data with covariates and excessive zeros. A model selection procedure is proposed to evaluate the significance of geographic clusters for the mixture scan statistic. Simulation studies and data analysis for associations between dengue infection and environmental risk factors are used to illustrate the proposed method.

## ✨ Key Features & Workflow

* **Candidate Cluster Generation**: Automatically generates potential spatial cluster candidates (`candidate`) based on centroid distances derived from spatial polygons (`sf`).
* **Single Cluster Hypothesis Testing**: Evaluates individual cluster candidates while adjusting for zero inflation and covariates using Marginalized Estimating Equations (`MEE`).
* **Cluster Regrouping**: Merges significant single clusters based on spatial adjacency (`spdep`) to construct candidate spatial patterns (`regroup`).
* **Multiple Model Selection**: Evaluates combined cluster effects in a multiple regression model to filter out non-significant clusters and avoid over-clustering.
* **Spatial Visualization**: Automatically produces visual spatial plots (`clusters_plot`) overlaying detected clusters on the target study region.

## 📁 Package Structure

```text
MS/
├── R/             # Core functions (identification, candidate, regroup, MEE, clusters_plot)
├── data/          # Example datasets (data.rda) and study region spatial data
├── man/           # Documentation files (.Rd)
├── DESCRIPTION    # Package metadata and dependencies
└── NAMESPACE      # Exported functions and imported packages
```

## 📦 Installation

### Install from GitHub
You can install the development version of `MS` directly from GitHub using `remotes`:

```R
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

remotes::install_github("Thomas11411/spatial-clustering-detection")
```

### Install Local Source Package (`.tar.gz`)
If you have the source package file locally:

```R
install.packages("path/to/MS_0.1.0.tar.gz", repos = NULL, type = "source")
```

## 🚀 Quick Start / Usage Example

Below is the standard execution workflow using the `MS` package to identify spatial clusters:

```R
library(MS) # Mixture Scan Statistics

# 1. Load your dataset and study region polygon
# Load spatial dataset containing `response` and `covariate`
load("data.rda") 

# 2. Run Spatial Cluster Identification with Execution Timing
t0 <- Sys.time()

fit <- identification(
  response = data$response,
  covariate = data$covariate,
  study.region = study.region,
  max.dist = 0.75,
  cutoff = 0.5
)

t1 <- Sys.time()

# Check computation duration
print(t1 - t0)

# 3. View Detection Results & Visualization Plot
print(fit)
print(fit$clust.plot)
```

## 📄 Citation & License

If you use this package or methodology in your research, please cite the corresponding paper on mixture scan statistics.

This project is licensed under the MIT License - see the `LICENSE` file for details.