/*  This file is part of corebird, a Gtk+ linux Twitter client.
 *  Copyright (C) 2016 Timm Bäder
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

#ifndef _CB_INLINE_MEDIA_DOWNLOADER_H_
#define _CB_INLINE_MEDIA_DOWNLOADER_H_

#include <glib-object.h>
#include <libsoup/soup.h>
#include "CbMedia.h"
#include "CbTypes.h"

G_BEGIN_DECLS

struct _CbMediaDownloader
{
  GObject parent_instance;

  GCancellable *cancellable;
  guint         disabled : 1;
};

typedef struct _CbMediaDownloader CbMediaDownloader;

#define CB_TYPE_MEDIA_DOWNLOADER (cb_media_downloader_get_type ())
G_DECLARE_FINAL_TYPE (CbMediaDownloader, cb_media_downloader, CB, MEDIA_DOWNLOADER, GObject);

CbMediaDownloader * cb_media_downloader_get_default (void);
void                cb_media_downloader_load_all    (CbMediaDownloader  *downloader,
                                                    CbMiniTweet        *t);
void                cb_media_downloader_load_async  (CbMediaDownloader   *downloader,
                                                     CbMedia             *media,
                                                     GAsyncReadyCallback  callback,
                                                     gpointer             user_data);
gboolean            cb_media_downloader_load_finish (CbMediaDownloader  *downloader,
                                                     GAsyncResult       *result,
                                                     GError            **error);
void                cb_media_downloader_disable     (CbMediaDownloader *downloader);
void                cb_media_downloader_shutdown    (CbMediaDownloader *downloader);
gboolean            is_media_candidate              (const char *url);

G_END_DECLS

#endif
