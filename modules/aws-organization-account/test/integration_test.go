//go:build integration

package test

import (
	"testing"
	//"fmt"
	//"strings"
	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/gruntwork-io/terratest/modules/random"
	//"github.com/stretchr/testify/assert"
)
func TestTerraformValidate(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/simple",
	})
	terraform.InitAndValidate(t, terraformOptions)
}

// AWS accounts can't be deleted until at least one hour after they are created.
// so this test is disabled.
/*
func TestTerraformSimpleExample(t *testing.T) {
	expectedName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))
	expectedEmail := fmt.Sprintf("%s@example.com", strings.ToLower(random.UniqueId()))
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/simple",
		Vars: map[string]interface{}{
			"name": expectedName,
			"email": expectedEmail,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	output := terraform.OutputMap(t, terraformOptions, "result")
	assert.Equal(t, expectedName, output["name"])
	assert.Equal(t, expectedEmail, output["email"])
}
*/
