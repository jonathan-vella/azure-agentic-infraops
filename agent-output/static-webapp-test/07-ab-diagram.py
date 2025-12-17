#!/usr/bin/env python3
"""
Step 7: As-Built Diagram - static-webapp-test

Architecture diagram showing deployed infrastructure.
As-built phase (-ab suffix) documenting actual deployment.

Generated: 2024-12-17
Phase: As-Built (Step 7)
"""

from diagrams import Cluster, Diagram, Edge
from diagrams.azure.web import AppServices
from diagrams.azure.compute import FunctionApps
from diagrams.azure.database import SQLDatabases
from diagrams.azure.identity import ActiveDirectory
from diagrams.azure.devops import ApplicationInsights
from diagrams.azure.analytics import LogAnalyticsWorkspaces
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Github

# Diagram configuration
graph_attr = {
    "fontsize": "14",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "ortho",
    "label": "As-Built Architecture - static-webapp-test\nDeployed: 2024-12-17 | Region: swedencentral",
    "labelloc": "t",
    "fontcolor": "#333333",
}

with Diagram(
    "Static Web App - As-Built",
    filename="07-ab-diagram",
    show=False,
    direction="LR",
    graph_attr=graph_attr,
    outformat="png",
):
    # External
    users = Users("Internal Users\n(10 users)")
    github = Github("GitHub\n(CI/CD)")

    # Identity
    aad = ActiveDirectory("Azure AD\n(Authentication)")

    with Cluster("rg-static-webapp-test-dev\nswedencentral"):

        with Cluster("Frontend & API Layer"):
            swa = AppServices("stapp-static-webapp-test-dev\nFree Tier")
            func = FunctionApps("Integrated Functions\nConsumption")

        with Cluster("Data Layer"):
            sql = SQLDatabases("sql-staticweba-dev-xxx\nS0 (10 DTU)")
            sqldb = SQLDatabases("sqldb-static-webapp-test-dev\n250GB max")

        with Cluster("Monitoring & Logging"):
            insights = ApplicationInsights(
                "appi-static-webapp-test-dev\nBasic")
            logs = LogAnalyticsWorkspaces(
                "log-static-webapp-test-dev\n30-day retention")

    # User flow
    users >> Edge(label="HTTPS") >> aad
    aad >> Edge(label="Token") >> swa

    # CI/CD flow
    github >> Edge(label="Deploy", style="dashed") >> swa

    # Internal flow
    swa >> Edge(label="API") >> func
    func >> Edge(label="AAD Auth") >> sql
    sql - sqldb

    # Monitoring (dashed)
    swa >> Edge(style="dashed", color="gray") >> insights
    func >> Edge(style="dashed", color="gray") >> insights
    sql >> Edge(style="dashed", color="gray") >> insights
    insights >> Edge(style="dashed", color="gray") >> logs
