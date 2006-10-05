class CanvasContextMenu extends ContextMenu{
	var copy:ContextMenuItem;
	var paste:ContextMenuItem;
	
	function CanvasContextMenu(main) {
		hideBuiltInItems();
		copy = new ContextMenuItem("Copy.");
		copy.enabled = false;
		copy.onSelect = function(obj, menuItem) {
			main.copyOnClipboardSelectedShapes();
		};
		paste = new ContextMenuItem("Paste.");
		paste.enabled = main.existShapesOnClipboard();
		paste.onSelect = function(obj, menuItem) {
			main.pasteShapesFromClipboard();
		}
		customItems.push(copy);
		customItems.push(paste);
		_root.menu = this;
	}
	public function enableCopy() {
		copy.enabled = true;
	}
	public function disableCopy() {
		copy.enabled = false;
	}
	public function enablePaste() {
		paste.enabled = true;
	}
	public function disablePaste() {
		paste.enabled = false;
	}
}