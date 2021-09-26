/*
Simple DirectMedia Layer
Java source code (C) 2009-2014 Sergii Pylypenko

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required. 
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

package net.sourceforge.clonekeenplus;

import org.libsdl.app.SDLActivity;

import android.app.Activity;
import android.app.Service;
import android.content.Context;
import android.os.Bundle;
import android.os.IBinder;
import android.view.MotionEvent;
import android.view.KeyEvent;
import android.view.Window;
import android.view.WindowManager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.EditText;
import android.text.Editable;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.graphics.drawable.Drawable;
import android.graphics.Color;
import android.content.res.Configuration;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.view.View.OnKeyListener;
import android.view.MenuItem;
import android.view.Menu;
import android.view.Gravity;
import android.text.method.TextKeyListener;
import java.util.LinkedList;
import java.io.SequenceInputStream;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.CheckedInputStream;
import java.util.zip.CRC32;
import java.util.Set;
import android.text.SpannedString;
import java.io.BufferedReader;
import java.io.BufferedInputStream;
import java.io.InputStreamReader;
import android.view.inputmethod.InputMethodManager;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import java.util.concurrent.Semaphore;
import android.content.pm.ActivityInfo;
import android.view.Display;
import android.util.DisplayMetrics;
import android.text.InputType;
import android.util.Log;
import android.view.Surface;
import android.app.ProgressDialog;
import android.app.KeyguardManager;
import android.view.ViewTreeObserver;
import android.graphics.Rect;
import android.view.InputDevice;
import android.inputmethodservice.KeyboardView;
import android.inputmethodservice.Keyboard;
import android.app.Notification;
import android.app.PendingIntent;
import java.util.TreeSet;
import android.app.UiModeManager;
import android.Manifest;
import android.content.pm.PermissionInfo;
import java.util.Arrays;
import java.util.zip.ZipFile;
import java.util.ArrayList;


public class MainActivity extends SDLActivity
{
	@Override
	protected String[] getArguments() {
		String commandline = Globals.CommandLine;
		//return new String[0];
		return commandline.split(" ");
	}

	@Override
	protected String[] getLibraries() {
		return new String[] {
			"hidapi",
			"SDL2",
			// "SDL2_image",
			// "SDL2_mixer",
			// "SDL2_net",
			// "SDL2_ttf",
			"application",
			"sdl_main"
		};
	}

	@Override
	protected String getMainFunction() {
		return "SDL_main_stub";
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//copyAssets();

		class Callback implements Runnable
		{
			MainActivity p;
			Callback( MainActivity _p ) { p = _p; }
			public void run()
			{
				try {
					Thread.sleep(200);
				} catch( InterruptedException e ) {};

				Settings.Load(p);

				//if( !Settings.settingsChanged )
				{
					if( Globals.StartupMenuButtonTimeout > 0 )
					{
						Log.i("SDL", "libSDL: " + String.valueOf(Globals.StartupMenuButtonTimeout) + "-msec timeout in startup screen");
						try {
							Thread.sleep(Globals.StartupMenuButtonTimeout);
						} catch( InterruptedException e ) {};
					}
					//if( Settings.settingsChanged )
					//	return;
					Log.i("SDL", "libSDL: Timeout reached in startup screen, process with downloader");
					p.startDownloader();
				}
			}
		};

		Thread t = (new Thread(new Callback(this)));
		t.start();
		try {
			t.join();
		} catch( InterruptedException e ) {};
	}

	public void setUpStatusLabel()
	{
		MainActivity Parent = this; // Too lazy to rename
		//if( Parent._btn != null )
		//{
		//	Parent._layout2.removeView(Parent._btn);
		//	Parent._btn = null;
		//}
		if( Parent._tv == null )
		{
			//Get the display so we can know the screen size
			Display display = getWindowManager().getDefaultDisplay();
			int width = display.getWidth();
			int height = display.getHeight();
			Parent._tv = new TextView(Parent);
			Parent._tv.setMaxLines(2); // To show some long texts on smaller devices
			Parent._tv.setMinLines(2); // Otherwise the background picture is getting resized at random, which does not look good
			Parent._tv.setText(R.string.init);
			// Padding is a good idea because if the display device is a TV the edges might be cut off
			Parent._tv.setPadding((int)(width * 0.1), (int)(height * 0.1), (int)(width * 0.1), 0);
			//Parent._layout2.addView(Parent._tv);
		}
	}

	public void startDownloader()
	{
		Log.i("SDL", "libSDL: Starting data downloader");
		class Callback implements Runnable
		{
			public MainActivity Parent;
			public void run()
			{
				setUpStatusLabel();
				Log.i("SDL", "libSDL: Starting downloader");
				if( Parent.downloader == null )
					Parent.downloader = new DataDownloader(Parent, Parent._tv);
			}
		}
		Callback cb = new Callback();
		cb.Parent = this;
		this.runOnUiThread(cb);
	}

	private static DataDownloader downloader = null;

	private TextView _tv = null;

	public boolean writeExternalStoragePermissionDialogAnswered = true;

	private void copyAssets() {
		AssetManager assetManager = getAssets();
		String[] files = null;
		try {
			files = assetManager.list("");
		} catch (IOException e) {
			Log.e("tag", "Failed to get asset file list.", e);
		}
		if (files != null) for (String filename : files) {
			InputStream in = null;
			OutputStream out = null;
			try {
			in = assetManager.open(filename);
			File outFile = new File(getExternalFilesDir(null), filename);
			out = new FileOutputStream(outFile);
			copyFile(in, out);
			} catch(IOException e) {
				Log.e("tag", "Failed to copy asset file: " + filename, e);
			}     
			finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException e) {
						// NOOP
					}
				}
				if (out != null) {
					try {
						out.close();
					} catch (IOException e) {
						// NOOP
					}
				}
			}  
		}
	}
	private void copyFile(InputStream in, OutputStream out) throws IOException {
		byte[] buffer = new byte[1024];
		int read;
		while((read = in.read(buffer)) != -1){
		out.write(buffer, 0, read);
		}
	}
}
