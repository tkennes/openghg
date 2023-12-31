package filter

//
//import (
//	"fmt"
//	"github.com/tkennes/openghg/pkg/kubecost"
//	"github.com/tkennes/openghg/pkg/log"
//)
//
//type Windowed interface {
//	GetWindow() kubecost.Window
//}
//
//// WindowOperation are operations that can be performed on types that have windows
//type WindowOperation string
//
//const (
//	WindowContains WindowOperation = "windowcontains"
//)
//
//// WindowCondition is a filter can be used on any type that has a window and implements GetWindow()
//type WindowCondition[T Windowed] struct {
//	Window kubecost.Window
//	Op     WindowOperation
//}
//
//func (wc WindowCondition[T]) String() string {
//	return fmt.Sprintf(`(%s "%s")`, wc.Op, wc.Window.String())
//}
//
//func (wc WindowCondition[T]) Matches(that T) bool {
//	thatWindow := that.GetWindow()
//	switch wc.Op {
//	case WindowContains:
//		return wc.Window.ContainsWindow(thatWindow)
//	default:
//		log.Errorf("Filter: Window: Unhandled filter operation. This is a filter implementation error and requires immediate patching. Op: %s", wc.Op)
//		return false
//	}
//}
