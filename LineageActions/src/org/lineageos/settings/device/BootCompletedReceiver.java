/*
 * Copyright (c) 2015 The CyanogenMod Project
 * Copyright (c) 2017 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings.device;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.om.IOverlayManager;
import android.content.om.OverlayInfo;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.provider.Settings;
import android.util.Log;

import org.lineageos.settings.device.ServiceWrapper.LocalBinder;

public class BootCompletedReceiver extends BroadcastReceiver {
    static final String TAG = "LineageActions";
    static final String ravOverlayPackageName = "org.omnirom.overlay.moto.rav";
    private ServiceWrapper mServiceWrapper;
    private static OverlayManager sOverlayService;

    @Override
    public void onReceive(final Context context, Intent intent) {
        Log.i(TAG, "Booting");
        context.startService(new Intent(context, ServiceWrapper.class));

	if (sOverlayService == null) {
            sOverlayService = new OverlayManager();
        }
        try {
            String deviceProp = SystemProperties.get("ro.product.product.device", "sofia");
            if (deviceProp.contains("rav")) {
                boolean isEnabled = sOverlayService.getOverlayInfo(ravOverlayPackageName,
                    UserHandle.myUserId()).isEnabled();
                if (!isEnabled) {
                    sOverlayService.setEnabled(ravOverlayPackageName, true,
                        UserHandle.myUserId());
                }
            }
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName className, IBinder service) {
            LocalBinder binder = (LocalBinder) service;
            mServiceWrapper = binder.getService();
            mServiceWrapper.start();
        }

        @Override
        public void onServiceDisconnected(ComponentName className) {
            mServiceWrapper = null;
        }
    };

    public static class OverlayManager {
        private final IOverlayManager mService;

        public OverlayManager() {
            mService = IOverlayManager.Stub.asInterface(
                    ServiceManager.getService(Context.OVERLAY_SERVICE));
        }

        public void setEnabled(String pkg, boolean enabled, int userId)
                throws RemoteException {
            mService.setEnabled(pkg, enabled, userId);
        }

        public OverlayInfo getOverlayInfo(String target, int userId)
                throws RemoteException {
            return mService.getOverlayInfo(target, userId);
        }
    }    
}
