## purpose centralize secret/env

---

### AWS secret manager

    1. management secret using terraform(set(string)), text file
    2. interact by aws cli
    3. use jq to convert/revert secret value to text/json

### command

1. dowload secret value save to .env

   ```sh
   aws secretsmanager get-secret-value --secret-id $SECRET_ID --region $REGION | jq -r ".SecretString"
   ```
