---
description: Delete Terraform state locks from DynamoDB
---
# Terraform State Lock Removal

Remove stuck Terraform state locks from DynamoDB.

Review the user input to extract the following
`[profile] [region] [project]`

example: jupiterone-dev, us-east-1, juno-ai
Then run a script like the following to remove the lock from terraform

ARGS=($ARGUMENTS)
AWS_PROFILE="${ARGS[0]:-jupiterone-dev}"
AWS_REGION="${ARGS[1]:-us-east-1}"
PROJECT="${ARGS[2]:-juno-ai}"

echo "🔓 Removing Terraform lock for $PROJECT"

## Find and delete locks

# The actual lock ID in DynamoDB (not the -md5 version)
LOCK_ID="jupiterone-infra-state/$AWS_PROFILE/$PROJECT/terraform.tfstate"

# Check for lock
LOCK=$(aws dynamodb get-item \
  --table-name terraform-state-lock \
  --key "{\"LockID\": {\"S\": \"$LOCK_ID\"}}" \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" \
  --output json 2>/dev/null)

if [ -z "$LOCK" ] || [ "$LOCK" = "{}" ]; then
  echo "No lock found"
else
  # Extract lock info if available
  INFO=$(echo "$LOCK" | jq -r '.Item.Info.S // empty' | jq -r 'select(. != null) | "ID: \(.ID)\nWho: \(.Who)\nCreated: \(.Created)"' 2>/dev/null)
  [ -n "$INFO" ] && echo -e "Lock details:\n$INFO"

  # Delete the lock
  aws dynamodb delete-item \
    --table-name terraform-state-lock \
    --key "{\"LockID\": {\"S\": \"$LOCK_ID\"}}" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"

  echo "✓ Lock deleted"
fi

# Also check for the -md5 variant
LOCK_MD5="$LOCK_ID-md5"
aws dynamodb delete-item \
  --table-name terraform-state-lock \
  --key "{\"LockID\": {\"S\": \"$LOCK_MD5\"}}" \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" 2>/dev/null

echo "Done!"