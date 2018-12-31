# Azure DevOps Pipelines Infrastructure Building Blocks Startup Kit
Startup Kit and documentation on getting started with Azure DevOps (dev.azure.com) Pipelines that includes examples, content and pipelines that can be imported

An Azure DevOps pipeline allows a list of repeatable tasks to be executed in an Azure environment such as creating a virtual machine. There are many options when considering automating Azure deployment using Azure DevOps pipelines (https://dev.azure.com). The goal of this document is outline common scripting language choices and provide detail in how to use them starting with the simplest and working towards more complex structures. Examples will be provided both as importable pipelines and step by step instructions to get you running right away. One concept that will be highlighted is creating modular pipelines that maximize code reuse from this github repo.

Powershell is covered heavily with more chapters to come around ARM and Powershell DSC

## Sub-directories contain content divided by type
Library of standalone Powershell Scripts that support Infrastructure as Code tasks
Library of Azure Powershell Tasks with inline powershell
Library of importable DevOps pipelines
