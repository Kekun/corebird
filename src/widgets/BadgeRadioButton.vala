/*  This file is part of corebird, a Gtk+ linux Twitter client.
 *  Copyright (C) 2013 Timm Bäder
 *
 *  corebird is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  corebird is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with corebird.  If not, see <http://www.gnu.org/licenses/>.
 */

public class BadgeRadioButton : Gtk.RadioButton {
  private const int BADGE_SIZE = 10;
  private bool _show_badge = false;
  public bool show_badge {
    set {
      debug ("New show_badge value: %s", value ? "true" : "false");
      if (value != this._show_badge) {
        this._show_badge = value;
        this.queue_draw ();
      }
    }
    get {
      return this._show_badge;
    }
  }

  public BadgeRadioButton (Gtk.RadioButton group, string icon_name, string text="") {
    GLib.Object (group: group);
    this.get_style_context ().add_class ("image-button");
    var i = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.BUTTON);
    this.add (i);
    this.set_mode (false);
    this.focus_on_click = false;
    this.hexpand = true;
    i.margin_start = i.margin_end = 6;

    if (text != "") {
      this.tooltip_text = text;
      Atk.Object accessible = this.get_accessible ();
      accessible.set_name (text);
    }
  }

  public override void adjust_size_request (Gtk.Orientation orientation, ref int minimum_size, ref int natural_size) {
    if (orientation == Gtk.Orientation.VERTICAL)
      return;

    natural_size = minimum_size * 2;
  }

  public override bool draw (Cairo.Context ct) {
    base.draw (ct);
    if (!show_badge || this.get_child () == null)
      return Gdk.EVENT_PROPAGATE;


    Gtk.Allocation allocation;
    var child = this.get_child ();
    var child_requisition = child.get_requisition ();
    this.get_allocation (out allocation);

    var context = this.get_style_context ();
    int x = int.max ((allocation.width - child_requisition.width) / 2 + child_requisition.width - child.margin_right, 3);
    int y = int.max ((allocation.height - child_requisition.height) / 2 + child.margin_top - BADGE_SIZE, BADGE_SIZE / 2 + 3);

    context.save ();
    context.add_class ("badge");
    context.render_background (ct, x, y, BADGE_SIZE, BADGE_SIZE);
    context.render_frame      (ct, x, y, BADGE_SIZE, BADGE_SIZE);
    context.restore ();

    return Gdk.EVENT_PROPAGATE;
  }
}
