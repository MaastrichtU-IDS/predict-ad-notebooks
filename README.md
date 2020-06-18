## PredictAD

PredictAD project exploring data from the [Alzheimer’s Disease Neuroimaging Initiative](http://adni.loni.usc.edu/). Apply to get ADNI data at http://adni.loni.usc.edu/data-samples/access-data/

We use `ADNIMERGE.csv` data in this project. 

Run notebooks to generate model from the ADNI data:

* Create the FOLDS using `FOLD_CREATOR`
* Generate files used in `TRAIN`
* `RESULTS` folder is the merging of FOLDS previously generated

`FINAL_MODEL` is an experimental notebook for validation

## Data precleaning

Required to generate the `adnimerge_screen.xlsx` from the `ADNIMERGE.csv` file

Use the `DATA_PREPARATION` folder, starts with `PATIENT_SCREENING/data_preparation_patient_selection.ipynb`

For more details about the data preparation which includes manual steps, ask Massi and Nadine about the scripts

## How to cite

Grassi M, Rouleaux  N, Caldirola D, et al. [A Novel Ensemble-Based Machine Learning Algorithm to Predict the Conversion From Mild Cognitive Impairment to Alzheimer's Disease Using Socio-Demographic Characteristics, Clinical Information,  and Neuropsychological Measures](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6646724/). *Front Neurol*. 2019;10:756. Published 2019 Jul 16. doi:10.3389/fneur.2019.00756