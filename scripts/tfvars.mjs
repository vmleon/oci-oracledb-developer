#!/usr/bin/env zx

import Mustache from "mustache";
import tar from "tar";
import { readEnvJson } from "./lib/utils.mjs";

const shell = process.env.SHELL | "/bin/zsh";
$.shell = shell;
$.verbose = false;

const {
  compartmentId,
  compartmentName,
  regionName,
  tenancyId,
  publicKeyContent,
} = await readEnvJson();

await envTfvars();

await $`mkdir -p ./terraform/generated`;

await zipFolder(
  "./sqlplus_config/",
  "./terraform/generated/sqlplus_config.tar.gz"
);

console.log("\nFollow this steps to deploy infrastructure with Terraform:");
console.log(`1. ${chalk.yellow("cd terraform/")}`);
console.log(`2. ${chalk.yellow("terraform init")}`);
console.log(`3. ${chalk.yellow("terraform plan")}`);
console.log(`4. ${chalk.yellow("terraform apply -auto-approve")}`);

async function envTfvars() {
  const tfVarsPath = "terraform/terraform.tfvars";

  const tfvarsTemplate = await fs.readFile(`${tfVarsPath}.mustache`, "utf-8");

  const output = Mustache.render(tfvarsTemplate, {
    tenancyId,
    regionName,
    compartmentId,
    ssh_public_key: publicKeyContent,
  });

  console.log(
    `\nTerraform will deploy resources in ${chalk.green(
      regionName
    )} in compartment ${
      compartmentName ? chalk.green(compartmentName) : chalk.green("root")
    }`
  );

  await fs.writeFile(tfVarsPath, output);

  console.log(`File ${chalk.green(tfVarsPath)} created`);
}

async function zipFolder(folderPath, outputName) {
  await tar.c(
    {
      file: outputName,
      gzip: true,
      filter: (path) => {
        if (path.includes("node_modules")) {
          return false;
        }
        if (path.endsWith("/.env")) {
          return false;
        }
        return true;
      },
    },
    [folderPath]
  );
  console.log(
    `Folder ${chalk.green(folderPath)} compressed into ${chalk.green(
      outputName
    )}`
  );
}
