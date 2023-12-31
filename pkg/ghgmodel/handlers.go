package ghgmodel

import (
	"fmt"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/tkennes/openghg/pkg/env"
	assetfilter "github.com/tkennes/openghg/pkg/filter21/asset"
	"github.com/tkennes/openghg/pkg/filter21/ast"
	"github.com/tkennes/openghg/pkg/filter21/matcher"
	"github.com/tkennes/openghg/pkg/kubecost"
	"github.com/tkennes/openghg/pkg/util/httputil"
)

// ComputeAllocationHandler returns the assets from the CostModel.
func (a *Accesses) ComputeAssetsHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	w.Header().Set("Content-Type", "application/json")

	qp := httputil.NewQueryParams(r.URL.Query())

	// Window is a required field describing the window of time over which to
	// compute allocation data.
	window, err := kubecost.ParseWindowWithOffset(qp.Get("window", ""), env.GetParsedUTCOffset())
	if err != nil {
		http.Error(w, fmt.Sprintf("Invalid 'window' parameter: %s", err), http.StatusBadRequest)
		return
	}

	assetSet, err := a.Model.ComputeAssets(*window.Start(), *window.End())
	if err != nil {
		http.Error(w, fmt.Sprintf("Error computing asset set: %s", err), http.StatusInternalServerError)
		return
	}
	filterString := qp.Get("filter", "")

	var filter kubecost.AssetMatcher
	if filterString == "" {
		filter = &matcher.AllPass[kubecost.Asset]{}
	} else {
		parser := assetfilter.NewAssetFilterParser()
		tree, errParse := parser.Parse(filterString)
		if errParse != nil {
			http.Error(w, fmt.Sprintf("err parsing filter '%s': %v", ast.ToPreOrderShortString(tree), errParse), http.StatusBadRequest)
		}
		compiler := kubecost.NewAssetMatchCompiler()
		var err error
		filter, err = compiler.Compile(tree)
		if err != nil {
			http.Error(w, fmt.Sprintf("err compiling filter '%s': %v", ast.ToPreOrderShortString(tree), err), http.StatusBadRequest)
		}
	}
	if filter == nil {
		http.Error(w, fmt.Sprintf("unexpected nil filter"), http.StatusInternalServerError)
	}

	for key, asset := range assetSet.Assets {
		if !filter.Matches(asset) {
			delete(assetSet.Assets, key)
		}
	}

	w.Write(WrapData(assetSet, nil))
}
