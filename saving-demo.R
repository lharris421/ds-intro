## Example of saving results of empirical sampling distribution of beta coefficient
## in simple linear regression
set.seed(1234)

niter <- 1000
samp_size <- 10
betas <- rep(NA_real_, niter)
for (i in 1:niter) {

  x <- rnorm(samp_size, mean = 1, sd = 2)
  err <- rnorm(samp_size, mean = 0, sd = 1)
  y <- 1 + 2 * x + err
  betas[i] <- coef(lm(y ~ x))[2]

}

res <- list(
  meta = list(script_name = "saving-demo.R", beta1 = 2, err_sd = 1),
  beta1_coefs = betas
)

saveRDS(res, file = "tmp_dir/saving-demo.rds")

## Clear enviornment
rm(list = ls())

res <- readRDS("tmp_dir/saving-demo.rds")
hist(res$beta1_coefs)

## indexr example --------------------------------------------------------------
library(indexr)

# Example usage of save_objects
parameters_list <- list(
  seed = 1234,
  iterations = 1000,
  x_dist = "rnorm",
  x_dist_options = list(n = 10, mean = 1, sd = 2),
  error_dist = "rnorm",
  error_dist_options = list(n = 10, mean = 0, sd = 1),
  beta0 = 1,
  beta1 = 2,
  script_name = "saving-demo.R"
)

set.seed(parameters_list$seed)
betas <- numeric(parameters_list$iterations)
for (i in 1:parameters_list$iterations) {
  x <- do.call(parameters_list$x_dist, parameters_list$x_dist_options)
  err <- do.call(parameters_list$error_dist, parameters_list$error_dist_options)
  y <- parameters_list$beta0 + parameters_list$beta1*x + err
  betas[i] <- coef(lm(y ~ x))["x"]
}

save_objects(folder = "tmp_dir", results = betas, parameters_list = parameters_list, overwrite = TRUE)

## Clear enviornment
rm(list = ls())

# Example usage of read_objects
parameters_list <- list(
  seed = 1234,
  iterations = 1000,
  x_dist = "rnorm",
  x_dist_options = list(n = 10, mean = 1, sd = 2),
  error_dist = "rnorm",
  error_dist_options = list(n = 10, mean = 0, sd = 1),
  beta0 = 1,
  beta1 = 2,
  script_name = "saving-demo.R"
)

betas <- read_objects(folder = "tmp_dir", parameters_list = parameters_list)
hist(betas)



