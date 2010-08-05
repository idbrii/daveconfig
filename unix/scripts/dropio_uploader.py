#! /usr/bin/env python

#  Drop.io Upload Tool for GNOME
#  Copyright (C) 2008 Ryan Paul (SegPhault)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# standard lib imports
import threading, webbrowser
# required dependencies
import pycurl, simplejson

# Insert your API key here
API_KEY = ""

class UploadThread(threading.Thread):
  def __init__(self, drop_name, filename, token, callback=None, progress=None):
    threading.Thread.__init__(self)

    self.curl = pycurl.Curl()
    self.curl.setopt(pycurl.POST, 1)
    self.curl.setopt(pycurl.URL, "http://assets.drop.io/upload")
    self.curl.setopt(pycurl.NOPROGRESS, 0)
    if callback:
        self.curl.setopt(self.curl.WRITEFUNCTION, callback)
    if progress:
        self.curl.setopt(self.curl.PROGRESSFUNCTION, progress)
    self.curl.setopt(self.curl.HTTPPOST, [
      ("file", (self.curl.FORM_FILE, filename)),
      ("version", "1.0"),
      ("format", "json"),
      ("api_key", API_KEY),
      ("drop_name", drop_name),
      ("token", token)])

  def run(self):
    self.curl.perform()
    self.curl.close()

try:
    import gtk, pango
    class DropIoUploader(gtk.Window):
      def __init__(self, drop_name=None, filename=None, token=None):
        gtk.Window.__init__(self)
        self.set_title("Upload a file to Drop.io")

        self.set_border_width(10)
        layout = gtk.Table(3, 2, False)
        layout.set_col_spacing(0, 10)
        layout.set_row_spacings(10)

        self.drop = gtk.Entry()
        self.token = gtk.Entry()
        self.token.set_visibility(False)
        self.chooser = gtk.FileChooserButton("Select a file")

        if drop_name:
            self.drop.set_text(drop_name)
        if filename:
            self.chooser.set_uri(filename)
        if token:
            self.token.set_text(token)

        self.btnupload = gtk.Button(stock=gtk.STOCK_SAVE)
        self.btncancel = gtk.Button(stock=gtk.STOCK_CANCEL)
        self.btnupload.connect("clicked", self.on_press_upload)
        self.btncancel.connect("clicked", lambda w: self.destroy())

        layout.attach(gtk.Label("Drop name:"), 0, 1, 0, 1, gtk.FILL)
        layout.attach(self.drop, 1, 2, 0, 1, gtk.EXPAND|gtk.FILL)

        layout.attach(gtk.Label("Authentication:"), 0, 1, 1, 2, gtk.FILL)
        layout.attach(self.token, 1, 2, 1, 2, gtk.EXPAND|gtk.FILL)

        layout.attach(gtk.Label("Select file:"), 0, 1, 2, 3, gtk.FILL)
        layout.attach(self.chooser, 1, 2, 2, 3, gtk.EXPAND|gtk.FILL)

        self.status_layout = gtk.VBox()
        self.progressbar = gtk.ProgressBar()

        buttons = gtk.HButtonBox()
        buttons.set_spacing(10)
        buttons.set_layout(gtk.BUTTONBOX_END)
        buttons.pack_start(self.btncancel)
        buttons.pack_start(self.btnupload)

        vb = gtk.VBox(spacing=10)
        vb.pack_start(layout, True, True)
        vb.pack_start(self.status_layout)
        vb.pack_start(gtk.HSeparator())
        vb.pack_start(buttons)

        self.add(vb)

      def on_link_clicked(self, link_button):
        webbrowser.open(link_button.get_uri())

      def on_upload_progress(self, dt, dd, utotal, udone):
        if utotal:
          self.progressbar.set_fraction(float(udone) / float(utotal))

      def on_upload_finish(self, response):
        self.btnupload.set_sensitive(True)
        self.status_layout.remove(self.progressbar)

        try:
          data = simplejson.loads(response)
          url = "http://drop.io/%s/asset/%s" % (self.drop.get_text(), data["name"])
          self.response = gtk.LinkButton(url)
          self.response.connect("clicked", self.on_link_clicked)
        except:
          self.response = gtk.Label()
          self.response.set_markup("<b>Upload failed!</b>")

        self.status_layout.pack_start(self.response)
        self.response.show()

      def on_press_upload(self, btn):
        btn.set_sensitive(False)

        if hasattr(self, "response"):
          self.status_layout.remove(self.response)

        self.progressbar.set_fraction(0)
        self.status_layout.pack_start(self.progressbar)
        self.progressbar.show()

        UploadThread(
          self.drop.get_text(),
          self.chooser.get_filename(),
          self.token.get_text(),
          self.on_upload_finish,
          self.on_upload_progress).start()




    if __name__ == "__main__":
      window = DropIoUploader()
      window.connect("destroy", gtk.main_quit)
      window.show_all()

      gtk.gdk.threads_init()
      gtk.main()
except:
    # no support for gtk
    pass

try:
  import nautilus

  class DropIoExtension(nautilus.MenuProvider):
    def __init__(self):
      pass

    def on_file_upload(self, menu, file):
      DropIoUploader(filename = file).show_all()
      gtk.main()

    def get_file_items(self, window, files):
      if len(files) == 1:
        if not files[0].is_directory():
          item = nautilus.MenuItem(
            "NautilusPython::dropio_upload_file",
            "Upload to Drop.io",
            "Upload %s to Drop.io" % files[0].get_name(),
            "gnome-fs-share")

          item.connect("activate", self.on_file_upload, files[0].get_uri())

          return item,
except:
    # no nautilus
    pass


