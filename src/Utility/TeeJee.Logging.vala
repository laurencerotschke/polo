
/*
 * TeeJee.Logging.vala
 *
 * Copyright 2017 Tony George <teejeetech@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 *
 */
 
namespace TeeJee.Logging{

	/* Functions for logging messages to console and log files */

	using TeeJee.Misc;

	public DataOutputStream dos_log;
	public string err_log;
	public bool LOG_ENABLE = true;
	public bool LOG_TIMESTAMP = false;
	public bool LOG_COLORS = true;
	public bool LOG_DEBUG = false;
	public bool LOG_TRACE = false;
	public bool LOG_COMMANDS = false;

	public void log_msg (string message, bool highlight = false, bool is_warning = false){

		if (!LOG_ENABLE) { return; }

		string msg = "";

		if (LOG_COLORS){
			if (highlight){
				msg += "\033[1;38;5;34m";
			}
			else if (is_warning){
				msg += "\033[1;38;5;93m";
			}
		}

		if (LOG_TIMESTAMP){
			msg += "[" + timestamp(true) +  "] ";
		}

		if (is_warning){
			msg += "W: ";
		}
			
		msg += message;

		if (LOG_COLORS){
			msg += "\033[0m";
		}

		msg += "\n";

		stdout.printf (msg);
		stdout.flush();

		try {
			if (dos_log != null){
				dos_log.put_string ("[%s] %s\n".printf(timestamp(), message));
			}
		}
		catch (Error e) {
			stdout.printf (e.message);
		}
	}

	public void log_error(string message){
			
		if (!LOG_ENABLE) { return; }

		string msg = "";

		if (LOG_COLORS){
			msg += "\033[1;38;5;160m";
		}

		if (LOG_TIMESTAMP){
			msg += "[" + timestamp(true) +  "] ";
		}

		msg += "E: ";

		msg += message;

		if (LOG_COLORS){
			msg += "\033[0m";
		}

		msg += "\n";

		stderr.printf(msg);
		stderr.flush();
		
		try {
			string str = "[%s] E: %s\n".printf(timestamp(), message);
			
			if (dos_log != null){
				dos_log.put_string (str);
			}

			if (err_log != null){
				err_log += "%s\n".printf(message);
			}
		}
		catch (Error e) {
			stdout.printf (e.message);
		}
	}

	public void log_warning (string message){
		log_msg(message, true, true);
	}
	
	public void log_debug (string message, bool highlight = false){
		if (!LOG_ENABLE) { return; }

		if (LOG_DEBUG){
			log_msg ("D: " + message, highlight);
		}

		try {
			if (dos_log != null){
				dos_log.put_string ("[%s] %s\n".printf(timestamp(), message));
			}
		}
		catch (Error e) {
			stdout.printf (e.message);
		}
	}

	public void log_trace (string message){
		if (!LOG_ENABLE) { return; }

		if (LOG_TRACE){
			log_msg ("T: " + message);
		}

		try {
			if (dos_log != null){
				dos_log.put_string ("[%s] %s\n".printf(timestamp(), message));
			}
		}
		catch (Error e) {
			stdout.printf (e.message);
		}
	}

	public void log_to_file (string message, bool highlight = false){
		try {
			if (dos_log != null){
				dos_log.put_string ("[%s] %s\n".printf(timestamp(), message));
			}
		}
		catch (Error e) {
			stdout.printf (e.message);
		}
	}

	public void log_draw_line(){
		log_msg(string.nfill(70,'='));
	}

	public void show_err_log(Gtk.Window parent, bool disable_log = true){
		if ((err_log != null) && (err_log.length > 0)){
			//gtk_messagebox(_("Error"), err_log, parent, true);
		}

		if (disable_log){
			err_log_disable();
		}
	}

	public void err_log_clear(){
		err_log = "";
	}

	public string err_log_read(){
		return err_log;
	}

	public void err_log_disable(){
		err_log = null;
	}
}
