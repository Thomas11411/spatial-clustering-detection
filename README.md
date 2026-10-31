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

```
MS/
├── R/             # Core functions (identification, candidate, regroup, MEE, clusters_plot)
├── data/          # Example datasets and study region spatial data
├── man/           # Documentation files (.Rd)
├── DESCRIPTION    # Package metadata and dependencies
└── NAMESPACE      # Exported functions and imported packages
```

## 📦 Installation

You can install the development version of `MS` directly from GitHub using `remotes` or `devtools`:

```R
# Install remotes if you haven't already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Install the MS package from GitHub
remotes::install_github("Thomas11411/spatial-clustering-detection")
```

## 🚀 Quick Start / Usage Example

The primary function of this package is `identification()`, which accepts response counts, covariates, and spatial polygons (`sf`) to detect significant spatial clusters.

```R
library(MS)
library(sf)

# 1. Load your spatial polygon data (study region) and response variables
# Example: study_region is an `sf` polygon object containing spatial features
data("study_region_example") 

# Define response vector and matrix of covariates
y_response <- study_region_example$disease_cases
X_covariates <- as.matrix(study_region_example[, c("temp", "humidity", "rainfall")])

# 2. Run Spatial Cluster Identification
results <- identification(
  response = y_response,
  covariate = X_covariates,
  study.region = study_region_example,
  max.dist = 10,       # Maximum distance threshold (in km)
  cutoff = 0.05        # Significance cutoff point for model fitting
)

# 3. View Results & Plot Spatial Clusters
# Summary of final model fit
print(results)

# Display the cluster visualization map
print(results$clust.plot)
```

## 📄 Citation & License

If you use this package or methodology in your research, please cite the corresponding paper on mixture scan statistics.

This project is licensed under the MIT License - see the `LICENSE` file for details.