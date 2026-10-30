# Spatial Clustering Detection for Data with Covariates and Excessive Zeros (`MS`)

An R package for identifying spatial clusters and disease hotspots in zero-inflated spatial data with complex covariates using a mixture scan statistic.

---

## 📌 Background & Motivation

In the study of infectious diseases, cluster analysis is a useful statistical method to explore the relationship between disease hot spots and propagation patterns associated with risk factors. However, when covariates and excessive zeros also produce clustering effects for responses, traditional identification methods for geographic clusters may not address this confounding issue well. 

Moreover, for complex surveillance systems, scrutinizing all risk factors that could simultaneously affect health outcomes and geographic clusters would be difficult, which could cause large spatial variations and thus create a convergency issue for the Bayesian algorithm. 

To address these issues, a **mixture scan statistic** that is associated with the two-part and cluster models is developed to identify geographic clusters for spatial data with covariates and excessive zeros. A model selection procedure is proposed to evaluate the significance of geographic clusters for the mixture scan statistic. Simulation studies and data analysis for associations between dengue infection and environmental risk factors are used to illustrate the proposed method.

---

## ✨ Key Features

- **Zero-Inflated Spatial Data Handling**: Accurately addresses confounding clustering effects caused by excessive zeros and covariates.
- **Mixture Scan Statistic**: Integrates two-part models and spatial cluster models for robust cluster detection.
- **Model Selection & Inference**: Provides statistical testing and model selection procedures to evaluate cluster significance.
- **Epidemiological Application**: Demonstrated effectiveness using real-world dengue infection and environmental risk factor data.

---

## 📁 Package Structure

```text
MS/
├── R/             # Core algorithms and statistical functions
├── data/          # Example datasets (e.g., dengue infection data, environmental factors)
├── man/           # Documentation and help pages (.Rd files)
├── DESCRIPTION    # Package metadata and dependencies
└── NAMESPACE      # Exported functions and package imports
```

---

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

---

## 🚀 Quick Start / Usage Example

Here is a basic example demonstrating how to run the mixture scan statistic on your spatial dataset:

```R
library(MS)

# Load built-in example dataset
data("dengue_data")

# Run spatial cluster detection with covariates and zero-inflation control
results <- mixture_scan_detect(
  formula = cases ~ rainfall + temperature + humidity,
  data = dengue_data,
  coords = ~ long + lat,
  family = "zero_inflated_poisson"
)

# View summary of identified clusters
summary(results)

# Plot cluster map
plot(results)
```

---

## 📄 Citation / License

If you use this software or methodology in your research, please cite the corresponding paper.

This project is licensed under the MIT License - see the `LICENSE` file for details.