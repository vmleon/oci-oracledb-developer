# OCI OracleDB Developer

A playground for Oracle Cloud Infrastructure with Oracle Database for Developers

## Architecture

This project will deploy an **Autonomous Database** Shared and a **compute instance** with `sqlcl` installed on Oracle Cloud Infrastructure.

[SQLcl FAQ](https://www.oracle.com/database/technologies/appdev/sqlcl/sqlcl-faq.html)
[SQLcl Docs](https://docs.oracle.com/en/database/oracle/sql-developer-command-line/)

## Deploy infrastructure

```bash
cd scripts/ && npm install && cd ..
```

```bash
zx scripts/setenv.mjs
```

> Answer the Compartment name where you want to deploy the infrastructure. Root compartment is the default.

```bash
zx scripts/tfvars.mjs
```

```bash
cd terraform
```

```bash
terraform init
```

```bash
terraform plan --auto-approve
```

```bash
terraform apply --auto-approve
```

Run the command from the terraform output `compute`.

> The first time you connect with ssh (command above), SSH will ask you to confirm you want to add the fingerprint.
>
> Answer `yes`.
