package cloud

import (
	"time"

	"github.com/tkennes/openghg/pkg/kubecost"
)

// CloudCostIntegration is an interface for retrieving daily granularity CloudCost data for a given range
type CloudCostIntegration interface {
	GetCloudCost(time.Time, time.Time) (*kubecost.CloudCostSetRange, error)
}
