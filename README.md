# Azure DevOps Pipelines Infrastructure Building Blocks Startup Kit

An Azure DevOps pipeline allows a list of repeatable tasks to be executed in an
Azure environment such as creating a virtual machine. There are many options
when considering automating Azure deployment using Azure DevOps pipelines
(<https://dev.azure.com>). The goal of this document is outline common scripting
language choices and provide detail in how to use them starting with the
simplest and working towards more complex structures. Examples will be provided
both as importable pipelines and step by step instructions to get you running
right away. One concept that will be highlighted is creating modular pipelines
that maximize code reuse from an associated github repo.

Before starting any automation project It’s important to understand the scope of
your automation. If your system will eventually be supported by another group,
you should also understand their skill level and support capability.

When considering scope some questions you may ask are whether you are automating
a complete Azure environment that includes networking, resource group, compute,
storage, and configuration/code OR you are only automating a subset of these
components.

Another important topic is understanding whether the scripting you plan to use
will use either imperative or declarative syntax as described in detail
[here](https://www.powershellmagazine.com/2013/07/05/imperative-versus-declarative-syntax-in-powershell/).
In summary, imperative syntax lists specifically how a task will be completed
AND declarative allows assessment of the current state to determine if it is
compliant and then executes the appropriate changes to bring it into compliance.
Using imperative syntax scripts will execute a set of commands without
assessment.

Below is a list of common Microsoft scripting languages used for infrastructure
activities (network, resource groups, VMs) in Azure DevOps pipelines and the
syntax type used:

| Microsoft script                       | Syntax Type |
|----------------------------------------|-------------|
| Powershell                             | Imperative  |
| Azure Resource Manager (ARM) templates | Declarative |
| Powershell DSC                         | Declarative |

These scripting languages can be used in combinations to achieve the optimal
automation covering tasks such as modification/creation of Azure objects, VM
extensions, and guest VM configuration. Below is a list of common combinations:

| Microsoft script structure                                 | How they are used                                                                                                   |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| Powershell only                                            | Azure objects, VM extensions and guest VM config                                                                    |
| ARM templates                                              | Azure objects and VM extensions                                                                                     |
| ARM templates calling Powershell DSC                       | ARM for azure objects and VM extensions calling DSC for guest VM config                                             |
| ARM templates calling sub-ARM templates and Powershell DSC | ARM for azure objects and VM extensions calling DSC for guest VM config. Sub-ARM templates provide more modularity. |
| Powershell and Powershell DSC                              | Powershell for azure objects and VM extensions and DSC for guest VM config                                          |
| Combination                                                | Script language chosen for specific actions                                                                         |

If you add in third party scripting options, you have a long list of choices and
combinations. Understanding your available options will improve your pipeline
design for specific situations.

Let’s start with a discussion of the simplest which is Powershell only. More
complex structures will be detailed in additional sections.

Example 1: Azure Deployment with Azure DevOps – Powershell Only
----------------------------------------------------

Powershell provides a simple imperative method to deploy automation from Azure
DevOps.

As an example of how to use Powershell in Azure Pipelines we’ll deploy a virtual
machine into Azure with an associated resource group and virtual network. To
follow this example, you will need the following available:

-   **Azure Subscription (http://portal.azure.com)**

    -   Permission will be required to create objects and create a service
        connection (if not already available)

-   **Azure DevOps account (http://dev.azure.com)**

If you don’t already have an Azure subscription, trial information can be found
here: <https://azure.microsoft.com/en-us/offers/ms-azr-0044p>.

If you don’t already have an Azure DevOps account, trial information can be
found here:  
<https://azure.microsoft.com/en-us/services/devops>

The example will be simpler if your Azure Subscription and Azure DevOps account
are registered under the same Microsoft account.

### Azure DevOps Example Instructions

#### Download GitHub repo

If you would like to try the example, first download the github content from
<https://github.com/jriekse5555/InfrastructureAsCode-Powershell> by using the
Clone or download button as shown below.

![](media/9c138ddd2b10752fb008e5947e0bf197.png)

Once this is done unzip the resulting file. We’ll use this later.

#### Logon to Azure DevOps
Next, sign into to an Azure DevOps account (<https://dev.azure.com>). If you
don’t have one already there is a trial option using a Microsoft account such as
outlook.com.

#### Create an Azure DevOps Project
Next, you’ll need to create a project if don’t have one already.

-   If you want to create a new project, click the **Create Project** button on
    the right-side of the screen

![](media/3e48133256d22a0284b76ebccc4e80ac.png)

-   Then name the project and click **Create**.

![](media/9ce0ad8e26bd9c7bffe93e340dca583b.png)

-   You should now be on the main page of your new project

#### Initialize Azure DevOps Repository  
Next, we’ll initialize the Repository to hold files

-   Click **Repos** on the left and then **Files**

![](media/6e041507d0df1db19e0f2be5ec6a6343.png)

-   On the bottom of the right-pane click **Initialize**

![](media/d2eb898c805f1ba171d9f587d71a3c4c.png)

#### Create an Azure DevOps Release Pipeline

When working with Azure DevOps Pipelines the two primary types of pipelines are
build and release pipelines. Conceptually build pipelines are for
building/preparation activities such as compiling code or copying necessary
content from the DevOps repository to a storage account. Release pipelines are
for deploying or releasing content into the environment. Release pipelines
should be used for activities such as deploying code or virtual machines into
the environment. Release pipelines provide layered version control using a base
release pipeline and specific instantiations called releases.

For this example, you can either import a release pipeline from the associated
[github
repository](https://github.com/jriekse5555/InfrastructureAsCode-Powershell) OR
create a release pipeline step-by-step.

#### Create a blank release pipeline

Regardless of whether you are planning to import the release pipeline or create
one, you need to create a blank release pipeline first. The Azure DevOps portal
does not allow importing a release pipeline if none already exist and if you are
creating one from scratch this is the first step.

Within the Azure DevOps portal, click on **Pipelines**, then click **Releases**  


![](media/91efd128c1e366b42da41f8afb73600d.png)

If this is the first release pipeline you’ve created click the **New Pipeline**
button on the right

![](media/2f945ce3764861dba6d4476cb7fa21f6.png)

If you’ve created a release pipeline previously in the middle-pane click the
**New** button and choose **New release pipeline**

![](media/94c79a02e4fc8253fc4cddee04795be9.png)

On the next screen choose the **Empty Pipeline** at the top of the choices

![](media/727f33e5e0c9485fae6e20c7027dea23.png)

Close the option for changing the Stage Name with the X in the right-corner

![](media/9e7159d794a42c53df4959d0dcf9063b.png)

Save the changes to your release pipeline with the Save button in the
right-corner

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Next, choose whether you will import or create and follow only that section.

#### Scenario 1: Import the example release pipeline

With a blank release pipeline created and saved, navigate to the **Releases**
section

![](media/91efd128c1e366b42da41f8afb73600d.png)

If you’ve created a release pipeline previously in the middle-pane click the
**New** button and choose **Import release pipeline**

![](media/188460ccfb06d9327b604a2467eb2560.png)

Browse to the location of the release pipeline to import. You should have
downloaded the github repository in the first example step. The proper release
pipeline is on the following path in this repo.

*InfrastructureAsCode-Powershell\\Azure_DevOps_Pipelines_Infrastructure_BuildingBlocks\\Import_AzureDevOpsPipelines\\Release_Pipelines\\Example_Deploy_VM_with_Powershell.json*

![](media/1e4873bc445f928cd72c626d5459332d.png)

![](media/c8032f43bfca8a8e832be4ed21474d75.png)

Click the **Tasks** button or the Stage 1 link

![](media/de40957492bdf099ce65700af02e8e38.png)

![](media/667ce678c9339ebea5ac8c47af41a858.png)

Click on the first step that needs attention

![](media/1a61001279eb0adb0cf7929155e01d53.png)

In the right-pane, note the agent that is used to run the release. You can
change this to use the hosted 2019 version.

![](media/e8257c8995055d80b56b3e28fb351544.png)

You cannot save the release pipeline until all errors have been resolved.

Next, click on any remaining task steps with errors. You may be missing a
service connection in each of the remaining steps. You may see the following in
the right-pane.

![](media/684a2493e68b84b171767071779cf84e.png)

You will need a service connection between Azure DevOps and Azure. The service
connection is similar to a service account and provides the permission to alter
the Azure fabric from Azure DevOps.

If you already have a service connection available with appropriate permissions,
choose it.

![](media/28cfd3a90a2742a0625bba6f8907e424.png)

If you are using Azure DevOps for the first time and have not set a service
connection up previously, click the drop-down to determine if an Azure
subscription is listed. If a subscription is shown select it, then click the
button **Authorize** to allow the connection.

![](media/6d6f4338318f04a4885e29d27659ea8e.png)

If an Azure subscription is not available or you want to use a different one,
click on the **Manage** link. Then choose the following:

![](media/d94791813c55c72316510a1f4a19accf.png)

Then

![](media/c089cfe826b5a16945ebd0213983af5f.png)

The basic service connection screen will appear. Next click the full version
link to enter the necessary details. Setting this up is beyond the scope of this
document. A service connection is required to continue with this example.

![](media/b2e5ea32f13b223d5533675518de3c69.png)

Resolve any remaining tasks steps and then Save the release pipeline.

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Review the imported pipeline variables to ensure no changes are required to work
in your existing environment

![](media/ff184569e8787ae029599c9ce5060380.png)

The release pipeline should be complete.

Continue to the section **Test the release pipeline**. You can skip Scenario 2
which creates a release pipeline from scratch.

#### Scenario 2: Create the example release pipeline step-by-step

A blank release pipeline should be available based on the previous instructions.
If you don’t already have it open for editing, please navigate to it and click
Edit. Review the previous instructions if necessary.

Click on the name of your release pipeline and type in a new name of
**Example_Deploy_VM_with\_ Powershell**

![](media/6ab35cef77a14982c3bf275b4a0fe568.png)

Click on any white space on the page to set the new name

![](media/0979c14c218e9d65b17c6a7a881e836e.png)

Next, set the variables that will be used throughout the pipeline. Click the
**Variables** button along the ribbon

![](media/ff184569e8787ae029599c9ce5060380.png)

Note that you are in the **Pipeline variables** section. This section is for
variables for this specific pipeline. For variable reuse across pipelines,
variable groups can be created in the **Library**.

![](media/56ff4341c8a0f5cfb2b38cfcc9ed3caf.png)

For this example, create the following Pipeline variables by typing them in:

| **Variable Name** | **Value**       |
|-------------------|-----------------|
| localPass         | P\@ssw0rd123456 |
| localUser         | localUser       |
| Location          | EastUS          |
| Network           | BuildingBlocks  |
| ResourceGroup     | BuildingBlocks  |
| Subnet            | Subnet1         |
| VMName            | BuildingBlocks  |
| VMSize            | Standard_B2s    |

The localPass variable can be locked to hide the value:

![](media/18645925af909948ba0aa501df618541.png)

Change any variable values if required to accommodate your Azure environment.

This is a good time to save your work.

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Click the **Tasks** button to start creating task steps.

![](media/de40957492bdf099ce65700af02e8e38.png)

Click on Agent job.

![](media/dfc3468a8cc9ab96acfea1cc9ba4232d.png)

In the right-pane, note the agent that is used to run the release. You can
change this to use the hosted 2019 version.

![](media/e8257c8995055d80b56b3e28fb351544.png)

Click the + sign on the right of Agent Job to create a task.

![](media/88dbed6947aacb3124e4c63a48d1e076.png)

Type in **Azure Powershell** in the search box and click **Add** on the
resulting task.

![](media/5841807f6d0ae9743ef32b977989ee11.png)

Click on the new task

![](media/5c13aafcbdfd3050d2c21fc6b85ad0cc.png)

In the right-pane, several settings will need to be set.

Change the **Display Name** to **Create Resource Group.** If you want to deploy
to an existing resource group, you could skip this step and set the variable
appropriately.

![](media/d9ce25faa18593a4f376bec27a9fc6c6.png)

Next, you will choose or configure the service connection between Azure DevOps
and Azure. The service connection is similar to a service account and provides
the permission to alter the Azure fabric from Azure DevOps.

If you already have a service connection available with appropriate permissions,
choose it.

![](media/28cfd3a90a2742a0625bba6f8907e424.png)

If you are using Azure DevOps for the first time and have not set a service
connection up previously, click the drop-down to determine if an Azure
subscription is listed. If a subscription is shown select it, then click the
button **Authorize** to allow the connection.

![](media/6d6f4338318f04a4885e29d27659ea8e.png)

If an Azure subscription is not available or you want to use a different one,
click on the **Manage** link. Then choose the following:

![](media/d94791813c55c72316510a1f4a19accf.png)

Then

![](media/c089cfe826b5a16945ebd0213983af5f.png)

The basic service connection screen will appear. Next click the full version
link to enter the necessary details. Setting this up is beyond the scope of this
document. A service connection is required to continue with this example.

![](media/b2e5ea32f13b223d5533675518de3c69.png)

Returning to configuring the first task step, you should now have a service
connection set.

![](media/28cfd3a90a2742a0625bba6f8907e424.png)

Choose the inline Powershell option.

![](media/90ad720f682cec1b2541bdc0cafd6cf0.png)

Paste in the Powershell content to create a Resource Group using the pipeline
variables.

*\#Note all variables with the syntax "\$()" are DevOps variables that need to
be predefined*

*\# Create Resource Group*  
*New-AzureRMResourceGroup -Name "\$(ResourceGroup)" -Location "\$(Location)"*

Choose the option to use the latest Powershell version.

![](media/6a1c8eb01e45d66bce38e345719c1ad2.png)

The first step is done. Save the pipeline

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Right-click in the middle of the finished task step and choose **Clone
task(s)**.

![](media/900d1d7e2152b8c6aa844d81d9d05e79.png)

Click on the copied task step. Change the name to **Create Virtual Network and
Subnet**.

![](media/39ddc39170f427b1fe239d264e29c381.png)

Paste in the Powershell content to create the virtual network and subnet using
the pipeline variables.

*\#Note all variables with the syntax "\$()" are DevOps variables that need to
be predefined*

*\# Create Virtual Network*  
*\$virtualNetwork = New-AzureRMVirtualNetwork \`*  
*-ResourceGroupName "\$(ResourceGroup)" \`*  
*-Location "\$(Location)" \`*  
*-Name "\$(Network)" \`*  
*-AddressPrefix 11.0.0.0/16*

*\#Create Subnet*  
*Add-AzureRMVirtualNetworkSubnetConfig \`*  
*-Name "Subnet1" \`*  
*-AddressPrefix 11.0.0.0/24 \`*  
*-VirtualNetwork \$virtualNetwork*

*\#Associate subnet with virtual network*  
*\$virtualNetwork \| Set-AzureRMVirtualNetwork*

This step is done. Save the pipeline

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Right-click in the middle of the finished task step and choose **Clone
task(s)**.

![](media/900d1d7e2152b8c6aa844d81d9d05e79.png)

Click on the copied task step. Change the name to **Create Virtual Network and
Subnet**.

![](media/9fa9c41b0f4d06051ac0a1c16bc56ef9.png)

Paste in the Powershell content.

*\#Note all variables with the syntax "\$()" are DevOps variables that need to
be predefined*

*\# Creates variable for NIC name using DevOps variable for VMName with 'NIC'
suffix*  
*\$NICName = "\$(VMName)" + "NIC"*

*\# Gets Subnet ID for NIC creation*  
*\$vnet = Get-AzsureRMVirtualNetwork -Name "\$(Network)" -ResourceGroupName
"\$(ResourceGroup)"*  
*\$SubnetObject = \$vnet.Subnets[0].Id*

*\# Creates NIC using previous variables and DevOps variables*  
*\$NIC = New-AzureRmNetworkInterface -Name \$NICName -ResourceGroupName
"\$(ResourceGroup)" -Location "\$(Location)" -SubnetId \$SubnetObject -Force*

This step is done. Save the pipeline

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Right-click in the middle of the finished task step and choose **Clone
task(s)**.

![](media/900d1d7e2152b8c6aa844d81d9d05e79.png)

Click on the copied task step. Change the name to **Create Virtual Network and
Subnet**.

![](media/4a6ac08e07d94a3ffb963ae9c81a665a.png)

Paste in the Powershell content.

*\#Adds a public IP to a NIC*  
*\#Note all variables with the syntax "\$()" are DevOps variables that need to
be predefined*  
  
*\#Sets up Public IP object name*  
*\$PublicIPName = "Public-" + "\$(VMName)"*

*\#Creates Public IP object*  
*\$PublicIP = New-AzureRmPublicIpAddress -Name \$PublicIPName -ResourceGroupName
"\$(ResourceGroup)" -AllocationMethod Dynamic -Location "\$(Location)" -Force*

*\#Sets NIC Name that was created previously*  
*\$NICName = "\$(VMName)" + "NIC"*  
  
*\#Retrieves NIC object from name*  
*\$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "\$(ResourceGroup)"
-Name \$NICName*

*\#Assign public IP object to NIC*  
*\$nic.IpConfigurations[0].PublicIpAddress = \$PublicIP*

*\#Updates NIC object*  
*\$NIC \| Set-AzureRmNetworkInterface*

This step is done. Save the pipeline

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

Right-click in the middle of the finished task step and choose **Clone
task(s)**.

![](media/900d1d7e2152b8c6aa844d81d9d05e79.png)

Click on the copied task step. Change the name to **Create Virtual Network and
Subnet**.

![](media/6e354c2cec30bf62a93c91f39a3892df.png)

Paste in the Powershell content to create the virtual network and subnet using
the pipeline variables.

*\$localPass = ConvertTo-SecureString "\$(localPass)" -AsPlainText -Force*  
*\$NICName = "\$(VMName)" + "NIC"*

*\$NIC = Get-AzureRmNetworkInterface -ResourceGroupName "\$(ResourceGroup)"
-Name \$NICName*

*\$Credential = New-Object System.Management.Automation.PSCredential
("\$(localUser)", \$localPass)*

*\$VirtualMachine = New-AzureRmVMConfig -VMName "\$(VMName)" -VMSize
"\$(VMSize)"*  
*\$VirtualMachine = Set-AzureRmVMOperatingSystem -VM \$VirtualMachine -Windows
-ComputerName "\$(VMName)" -Credential \$Credential -ProvisionVMAgent
-EnableAutoUpdate*  
*\$VirtualMachine = Add-AzureRmVMNetworkInterface -VM \$VirtualMachine -Id
\$NIC.Id*  
*\$VirtualMachine = Set-AzureRmVMSourceImage -VM \$VirtualMachine -PublisherName
'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter' -Version
'latest'*  
*\$VirtualMachine = Set-AzureRmVMOSDisk -VM \$VirtualMachine -CreateOption
'FromImage' -StorageAccountType 'Standard_LRS' -Name "\$(VMName)-osdisk"*  
*\$VirtualMachine = Add-AzureRmVMDataDisk -VM \$VirtualMachine -Lun 0
-CreateOption 'Empty' -Name "\$(VMName)-datadisk1" -StorageAccountType
'Standard_LRS' -Caching None -DiskSizeinGB 127*  
*\$VirtualMachine = Set-AzureRmVMBootDiagnostics -VM \$VirtualMachine -Disable*

*New-AzureRmVM -ResourceGroupName "\$(ResourceGroup)" -Location "\$(Location)"
-VM \$VirtualMachine -Verbose*

This step is done. Save the pipeline

![](media/fd9a931636f57e229640c8f5e18f0a32.png)

#### Test the release pipeline

You should now have a completed release pipeline created by either import or
step-by-step.

A release pipeline can be deployed from several portal locations.

From the release pipeline edit view you can click the **Create a release**
button in the top-right corner.

![](media/aae9ba7700beb9722d705db78689c8b0.png)

From the release pipeline overview…

![](media/57b3feb9ebd5c15f0b5fc49f8434c770.png)

Either way with result in a final screen, click the **Create** button

![](media/981232dae4858152e8a89aa457c683da.png)

The deployment can be monitored within Azure DevOps.

Clicking the link after the release is created will show the status. Note that
the powershell commands in this example may generate errors upon multiple reruns
if objects like resource groups or virtual networks are already present. This
can be overcome by disabling steps that have already run or by other methods.

![](media/54d70703e7106c819894c25379fb753c.png)

If you hover you the middle status widget you can select the **Logs** button.

![](media/3b6fe6a0eb22303e4d92b84dd8fa9424.png)

You should soon see a successful deployment and can verify the objects exist
within Azure.

If you navigate to the resource group holding the objects you should the
objects.

![](media/1ef3cf8b9b2c103b085e8e81f97de29a.png)

![](media/4cde4f3f996989d6170296af537407ca.png)

By clicking on the virtual machine, you can **Connect** to the virtual machine
via RDP using the local admin and password configured in the variables

![](media/47b132454c8067d619e5719856ca501d.png)

Click **Download RDP File**

![](media/e4410c7452d1390bae9354192492fd1d.png)

**Open** the RDP file

![](media/ea67868cc65b25c73d4a1b204b4dd10d.png)

Click **Connect**

![](media/ea786ac3a6f3a13bfb1ac25858e62d4e.png)

Type in the credentials from the variables. Click **OK**

![](media/5451e62f452c89f4e0c6aeedaa127fc1.png)

Click **Yes**

![](media/8592c0d9c8f9d83af6163669e867fb9b.png)

You should be successfully logged in.

Thanks for using the example. Feel free to send any feedback to
<jriekse5555@hotmail.com>.

If you are interested in customizing the example further the associated github
repository <https://github.com/jriekse5555/InfrastructureAsCode-Powershell> has
content that may be useful.

![](media/9d2470c34431d9b63f360378eb72d448.png)

Example 2: Azure Deployment with Azure DevOps – Leveraging a Combination of Modular Techniques with a Release Pipeline (In Progress)
-------------------------------------------------------------------------------------------------------------------------

Moving on from the previous simple example, the next example will use several
more advanced declarative techniques executed serially by the pipeline. This
will continue to allow a high degree of customization using the simple graphical
pipeline interface and offer a higher degree of insurance that the desired state
is reached.

This example will also deploy a VM and will instead use individual ARM templates
for the NIC and virtual machine, and then Powershell DSC for configuration
inside the virtual machine. A release pipeline will be used.

Here is a graphic of the pipeline that will be constructed:

![](media/0aef1c3c510edc817e27283877fcba58.png)

Example to be continued as soon as possible…

#### Appendix A: Marking pipelines as favorites

To assist with finding your pipelines quickly you may wish to mark them as
favorites.

The following steps show you how to mark your pipelines as favorites.

![](media/91efd128c1e366b42da41f8afb73600d.png)

![](media/c54f91645cc95fe32e95de54ae3b4cad.png)

The folder icon has all the pipelines. The first icon only has recent pipelines.

Click on your pipeline and then mark it as a favorite.

![](media/66dc8850b82593800037d3191a44bc07.png)
