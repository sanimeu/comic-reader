/// Responsive classes shared by Windows and Android (decided by width, not platform).
/// compact  (< 700):    phone layout: bottom glass nav, stacked content, filter bottom sheet
/// medium   (700-1099): floating sidebar, single content column (right panel collapsed)
/// expanded (>= 1100):  floating sidebar + content + right panel
enum LayoutClass { compact, medium, expanded }

const double kCompactMax = 700;
const double kExpandedMin = 1100;

LayoutClass classifyWidth(double width) {
  if (width < kCompactMax) return LayoutClass.compact;
  if (width < kExpandedMin) return LayoutClass.medium;
  return LayoutClass.expanded;
}
