# pre-commit hooks

GIT hooks are implemented using [`pre-commit`](https://pre-commit.com/).

To install `pre-commit` follow [this](https://pre-commit.com/#install) guide.

After installing `pre-commit` and cloning this repo you can enable the hooks locally by running:

```bash
pre-commit install
pre-commit install --hook-type commit-msg
```

You can also run specific hooks on all files:

```bash
pre-commit run detect-private-key --all-files
```

or run all hooks on all files:

```bash
pre-commit run --all-files
```

for more options check `pre-commit` [documentation](https://pre-commit.com/#advanced)

**NOTE:** to run the hooks you should have installed the following tools:
* [`terraform`](https://www.terraform.io/downloads.html)
* [`terragrunt`](https://terragrunt.gruntwork.io/docs/getting-started/install/)
* [`tflint`](https://github.com/terraform-linters/tflint) and
* [`terraform-docs`](https://github.com/terraform-docs/terraform-docs) installed locally.
