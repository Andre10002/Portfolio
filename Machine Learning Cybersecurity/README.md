# Machine Learning for Cybersecurity: Network Attack Detection

Machine learning on a network-session dataset from a fictional financial organisation. Two tasks were tackled following the **CRISP-DM** framework:

- **Classification:** is a network session an `Attack` or `Benign`? (Naïve Bayes and Decision Tree)
- **Regression:** how long will a session last (`session_duration`)? (Linear Regression and Decision Tree Regressor)

Built for the *Fundamentals of AI & Data Science* module at TU Dublin.

## Business problem

The organisation has suffered costly cyberattacks on its network and wants an automated way to flag malicious sessions. A **missed attack costs far more than a false alarm**, so the success criterion was high **recall on the Attack class**, not overall accuracy.

## Dataset

`Dataset1_even_students.csv`: a synthetic dataset supplied for the module.

| | |
|---|---|
| **Size** | 6,000 sessions, 19 columns |
| **Classification target** | `is_attack`: 4,481 Benign (74.7%), 1,519 Attack (25.3%), so the classes are **imbalanced** |
| **Regression target** | `session_duration` (mean about 93, range 33 to 156) |
| **Network features** | `protocol`, `tcp_flags`, `port_number`, `bytes_sent`, `bytes_received`, `packet_rate`, `connection_count`, `session_retries`, `signal_strength` |
| **Login and user features** | `login_attempts`, `failed_logins`, `privilege_level`, `vpn_status`, `device_type`, `region` |
| **Detector output** | `anomaly_score` |

**Data quality problems found and fixed**

| Issue | Fix |
|---|---|
| `protocol` had inconsistent case (`TCP`/`tcp`, `UDP`/`Udp`) | Standardised to upper case |
| 420 missing values (7%) in each of `protocol`, `bytes_received`, `signal_strength` | Mode for the categorical column, median for the skewed numeric columns |
| `session_id` is a unique identifier | Dropped |

## Method

1. **Explore:** distributions, box plots by class, correlation heatmap, anomaly score by class, categorical features by class.
2. **Prepare:** cleaning as above, **two engineered features** (`bytes_ratio` = sent / received, `login_failure_rate` = failed / attempts), label encoding, stratified 70/30 train/test split (`random_state=42`), standard scaling for regression and min-max scaling for Complement Naïve Bayes (which needs non-negative inputs).
3. **Model:** a baseline and a tuned version of each model, tuned with `GridSearchCV` (stratified 10-fold for classification, 5-fold for regression).
4. **Evaluate:** classification report and confusion matrix on the held-out test set (1,800 sessions: 456 attacks, 1,344 benign); MAE, RMSE and R² for regression.

## Results

### Classification (Attack = positive class)

| Model | Accuracy | Attack precision | Attack recall | Attack F1 |
|---|---|---|---|---|
| *Always predict Benign (reference)* | *0.747* | - | *0.00* | - |
| Baseline Naïve Bayes (`alpha=0`) | 0.586 | 0.32 | **0.56** | 0.41 |
| Tuned Naïve Bayes (`alpha=10`, `norm=True`) | 0.742 | 0.39 | 0.03 | 0.06 |
| Baseline Decision Tree | 0.616 | 0.26 | 0.28 | 0.27 |
| Tuned Decision Tree (`max_depth=3`) | 0.746 | 0.49 | 0.06 | 0.11 |

### Regression (`session_duration`)

| Model | MAE | RMSE | R² |
|---|---|---|---|
| **Linear Regression** | **9.78** | **12.31** | **0.475** |
| Baseline Decision Tree Regressor | 14.94 | 18.63 | -0.201 |
| Tuned Decision Tree Regressor (`max_depth=5`) | 10.65 | 13.44 | 0.374 |

## Key findings

- **Accuracy was misleading.** The tuned classifiers reach 74 to 75% accuracy, but always predicting "Benign" scores 74.7%. Tuning for accuracy pushed both models towards predicting Benign almost everywhere, so they catch only 3 to 6% of attacks. The *untuned* Naïve Bayes found the most attacks (56%), at the cost of many false alarms.
- **Overfitting is visible.** The unconstrained tree scored 100% on training data and 61.6% on test data; limiting depth to 3 closed the gap (75.5% train, 74.6% test).
- **`anomaly_score` dominates the tree**, at about 81% of its feature importance. The engineered `login_failure_rate` ranks third, so the new feature added information.
- **Regression:** Linear Regression beat the tree (R² 0.475 against 0.374), suggesting a roughly linear relationship. Session duration is only moderately predictable from these features.

## How to run

**Requirements:** Python 3.9+, `pandas`, `numpy`, `scikit-learn` (1.2 or newer, for `ComplementNB(force_alpha=...)`), `matplotlib`, `seaborn`, and Jupyter or Google Colab.

```bash
git clone https://github.com/Andre10002/Portfolio-Projects.git
cd "Portfolio-Projects/Machine Learning Cybersecurity"
pip install pandas numpy scikit-learn matplotlib seaborn jupyter
jupyter notebook Project_Script_Model.ipynb
```

The notebook loads the data from a Colab path (`/content/Dataset1_even_students.csv`). Either run it in Google Colab and upload the CSV, or change that path to `Dataset1_even_students.csv`.

## Files

| File | Description |
|---|---|
| `Project_Script_Model.ipynb` | Full CRISP-DM workflow: exploration, preparation, modelling, evaluation |
| `Dataset1_even_students.csv` | Synthetic network-session dataset (6,000 rows) |

## Skills demonstrated

Python, pandas, scikit-learn, exploratory data analysis, data cleaning and feature engineering, hyperparameter tuning with cross-validation, classification and regression evaluation, and applying machine learning to a security problem.
