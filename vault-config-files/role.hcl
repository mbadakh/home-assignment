vault write auth/jwt/role/docker-hub-token - <<EOF
{
  "role_type": "jwt",
  "policies": ["docker-hub-token"],
  "token_explicit_max_ttl": 60,
  "user_claim": "user_email",
  "bound_claims": {
    "project_id": "4",
    "ref": "main",
    "ref_type": "branch"
  }
}
EOF

