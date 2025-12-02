// ============================================================================
// WAF Policy Module
// ============================================================================
// Creates Web Application Firewall policy for Front Door (PCI-DSS)
// ============================================================================

@description('Resource tags')
param tags object

@description('Name of the WAF policy')
param wafPolicyName string

// ============================================================================
// WAF Policy
// ============================================================================

resource wafPolicy 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2024-02-01' = {
  name: wafPolicyName
  location: 'global'
  tags: tags
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Prevention'
      requestBodyCheck: 'Enabled'
      customBlockResponseStatusCode: 403
      customBlockResponseBody: base64('{"error": "Request blocked by WAF policy"}')
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'Microsoft_DefaultRuleSet'
          ruleSetVersion: '2.1'
          ruleSetAction: 'Block'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.1'
        }
      ]
    }
    customRules: {
      rules: [
        {
          name: 'RateLimitRule'
          priority: 100
          enabledState: 'Enabled'
          ruleType: 'RateLimitRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 1000
          matchConditions: [
            {
              matchVariable: 'RemoteAddr'
              operator: 'IPMatch'
              negateCondition: true
              matchValue: [
                '10.0.0.0/8' // Internal networks excluded
              ]
            }
          ]
          action: 'Block'
        }
        {
          name: 'BlockBadBots'
          priority: 200
          enabledState: 'Enabled'
          ruleType: 'MatchRule'
          matchConditions: [
            {
              matchVariable: 'RequestHeaders'
              selector: 'User-Agent'
              operator: 'Contains'
              negateCondition: false
              matchValue: [
                'sqlmap'
                'nikto'
                'nmap'
                'masscan'
              ]
              transforms: [
                'Lowercase'
              ]
            }
          ]
          action: 'Block'
        }
      ]
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('WAF policy resource ID')
output wafPolicyId string = wafPolicy.id

@description('WAF policy name')
output wafPolicyName string = wafPolicy.name
