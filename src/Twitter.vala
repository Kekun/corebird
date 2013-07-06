/*  This file is part of corebird.
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

using Rest;
using Gee;

class Twitter {
	private static string token;
	private static string token_secret;
	private static int max_media_per_upload;
	private static int characters_reserved_per_media;
	private static int short_url_length;
	private static int short_url_length_https;
	private static int photo_size_limit;
//	public static OAuthProxy proxy;
	public static Gdk.Pixbuf no_avatar;
	public static Gdk.Pixbuf no_banner;
	public static Gdk.Pixbuf verified_icon;
	public static HashMap<string, Gdk.Pixbuf> avatars;


	/**
	 * Updates the config
	 */
	public static async void update_config(){
		// Check when the last update was
		var now = new GLib.DateTime.now_local();
		try{
			SQLHeavy.Query time_query = new SQLHeavy.Query(Corebird.db,
				"SELECT `update_config`, `characters_reserved_per_media`,
				`max_media_per_upload`, `photo_size_limit`, `short_url_length`,
				`short_url_length_https` FROM `common`;");
			SQLHeavy.QueryResult time_result = time_query.execute();
			int64 last_update = time_result.fetch_int64(0);
			var then = new GLib.DateTime.from_unix_local(last_update);

			var diff = then.difference(now);
			if (diff < GLib.TimeSpan.DAY * 7){
				Twitter.characters_reserved_per_media = time_result.fetch_int(1);
				Twitter.max_media_per_upload          = time_result.fetch_int(2);
				Twitter.photo_size_limit              = time_result.fetch_int(3);
				Twitter.short_url_length              = time_result.fetch_int(4);
				Twitter.short_url_length_https        = time_result.fetch_int(5);
				return;
			}
		}catch(SQLHeavy.Error e){
			warning("Error while querying config: %s", e.message);
			return;
		}



/*		var call = Twi_tter.proxy.new_call();
		call.set_method("GET");
		call.set_function("1.1/help/configuration.json");
		call.invoke_async.begin(null, (obj, res) => {
			try{
				call.invoke_async.end(res);
			} catch (GLib.Error e){
				warning("Error while refreshing config: %s", e.message);
			}
			string back = call.get_payload();
			Json.Parser parser = new Json.Parser();
			try{
				parser.load_from_data(back);
			}catch(GLib.Error e){
				warning("Error while parsing Json: %s\nData:%s", e.message, back);
				return;
			}

			var root = parser.get_root().get_object();
			Twitter.characters_reserved_per_media =
				(int)root.get_int_member("characters_reserved_per_media");
			Twitter.max_media_per_upload   = (int)root.get_int_member("max_media_per_upload");
			Twitter.photo_size_limit       = (int)root.get_int_member("photo_size_limit");
			Twitter.short_url_length       = (int)root.get_int_member("short_url_length");
			Twitter.short_url_length_https = (int)root.get_int_member("short_url_length_https");

			//Update the stuff in the database
			try{
				Corebird.db.execute(@"UPDATE `common` SET
				`update_config`='%d',
				`characters_reserved_per_media`='$characters_reserved_per_media',
				`photo_size_limit`='$photo_size_limit',
				`short_url_length`='$short_url_length',
				`short_url_length_https`='$short_url_length_https';".printf(now.to_unix()));
			}catch(SQLHeavy.Error e){
				error("Error while updating the twitter config: %s", e.message);
			}

			message("Updated the twitter configuration");
		});*/
	}

	public static int get_characters_reserved_by_media(){
		return characters_reserved_per_media;
	}
	public static int get_max_media_per_upload(){
		return max_media_per_upload;
	}
	public static int get_photo_size_limit(){
		return photo_size_limit;
	}
	public static int get_short_url_length(){
		return short_url_length;
	}
	public static int get_short_url_length_https(){
		return short_url_length_https;
	}
}
