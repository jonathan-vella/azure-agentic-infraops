#!/usr/bin/env python3
"""
Step 3: Design Diagram - static-webapp-test

Architecture diagram for Azure Static Web App with SQL Database.
Design phase (-des suffix) showing proposed architecture.

Generated: 2024-12-17
Phase: Design (Step 3)
"""

from diagrams import Cluster, Diagram, Edge
from diagrams.azure.web import AppServices
from diagrams.azure.compute import FunctionApps
from diagrams.azure.database import SQLDatabases
from diagrams.azure.identity import ActiveDirectory
from diagrams.azure.devops import ApplicationInsights
from diagrams.azure.analytics import LogAnalyticsWorkspaces
from diagrams.azure.general import Resourcegroups
from diagrams.onprem.client import Users

# Diagram configuration
graph_attr = {
    "fontsize": "14",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "ortho",
}

with Diagram(
    "Static Web App with Azure SQL",
    filename="03-des-diagram",
    show=False,
    direction="LR",
    graph_attr=graph_attr,
    outformat="png",
):
    # External users
    users = Users("Internal\nUsers")

    # Identity
    aad = ActiveDirectory("Azure AD\n(Authentication)")

    with Cluster("Resource Group: rg-static-webapp-test-dev"):

        with Cluster("Frontend & API"):
            swa = AppServices("Static Web App\n(Free Tier)")
            func = FunctionApps("Azure Functions\n(Integrated)")

        with Cluster("Data Tier"):
            sql = SQLDatabases("Azure SQL\n(S0 - 10 DTU)")

        with Cluster("Monitoring"):
            insights = ApplicationInsights("Application\nInsights")
            logs = LogAnalyticsWorkspaces("Log Analytics\n(Free Tier)")

    # Connections
    users >> Edge(label="HTTPS") >> aad
    aad >> Edge(label="Auth Token") >> swa
    swa >> Edge(label="API Calls") >> func
    func >> Edge(label="Managed Identity") >> sql

    # Monitoring connections (dashed)
    swa >> Edge(style="dashed", color="gray") >> insights
    func >> Edge(style="dashed", color="gray") >> insights
    insights >> Edge(style="dashed", color="gray") >> logs
