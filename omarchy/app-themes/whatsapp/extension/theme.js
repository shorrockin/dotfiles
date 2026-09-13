// WhatsApp assigns its palette to generated class names. Discover those classes
// from same-origin stylesheets, then put the locally generated Omarchy palette
// on the same selectors. The extension has no network or browser permissions.
const palette = document.createElement("style");
let previousCss = "";
let previousSheetCount = -1;

function paletteSelectors() {
  const selectors = new Set([":root"]);

  function visit(rules) {
    for (const rule of rules) {
      if (rule.cssRules) visit(rule.cssRules);
      if (rule.style?.getPropertyValue("--WDS-surface-default") && rule.selectorText) {
        selectors.add(rule.selectorText);
      }
    }
  }

  for (const sheet of document.styleSheets) {
    if (sheet.ownerNode === palette) continue;
    try {
      visit(sheet.cssRules);
    } catch {
      // Cross-origin stylesheets are intentionally inaccessible.
    }
  }

  return [...selectors].join(",\n");
}

async function applyPalette() {
  let css;
  try {
    const response = await fetch(chrome.runtime.getURL("theme.css"), { cache: "no-store" });
    css = await response.text();
  } catch {
    return;
  }

  const sheetCount = document.styleSheets.length;
  if (css === previousCss && sheetCount === previousSheetCount) return;

  palette.textContent = css.replace(/^:root\s*\{/m, `${paletteSelectors()} {`);
  if (!palette.isConnected) (document.head || document.documentElement).append(palette);
  previousCss = css;
  previousSheetCount = sheetCount;
}

applyPalette();
setInterval(applyPalette, 2000);
