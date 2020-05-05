<#
.Synopsis
    Create the bearer token to use on Practice Engine API Rests requests (header)
.DESCRIPTION 
    After creating your Application App ID and App Key, you can use this 
    to create the authorization header for your Practice Engine API Requests. 
.PARAMETER AppID 
    The Application ID generated from Practice Engine that is tied to a Practice Engine user. 
.PARAMETER AppKey
    The Application Key generated from Practice Engine that is tied to a Practice Engine user. 
.PARAMETER BaseURL
    The base URL of your Practice Engine site. The submitted URL must be a valid URL, for example
    https://mysite.practiceenginehosted.com would pass validation. 
.EXAMPLE
    C:\PS>$PEAuthHeader = Create-PEAuthorizationHeader -AppId 'd88f9b633f664d62b7c5126348f27dff' -AppKey 'WGGV0y3EiD9M/MZV12NbO/lYrE174u3M1yaV1jZf3lg=' -BaseURL 'https://mypesite.practiceenginehosted.com'

#>
function Create-PEAuthorizationHeader {
    
    [CmdletBinding()]
    param (

        # AppId The App ID generated from Practice Engine.
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $AppId,

        #AppKey The App Key (secret) generated from Practice Engine. 
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $AppKey,

        #BaseURL The base URL of your Practice Engine hosted website
        [Parameter(Mandatory=$True)]
        [ValidatePattern("https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&=]*)")]
        [string] $BaseURL
        
    )
    
    $AuthURL = $BaseURL + '/auth'

    $Response = Invoke-RestMethod -Uri ($AuthURL +'/.well-known/openid-configuration') -Method Get 

    $TokenURL = $Response.token_endpoint

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $AppId,$AppKey)))

    $PayLoad = @{
        grant_type = 'client_credentials'
        scope = 'pe.api'
    }

    $AuthToken = Invoke-RestMethod -Uri $TokenURL -Method Post -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $PayLoad

    #Output as Hashtable
    $BearerToken = @{
        'Authorization' = 'Bearer ' + $AuthToken.access_token
    }

    return $BearerToken
    
} # End Create-PEAuthorizationHeader