package com.virtus.gl.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.virtus.gl.BuildConfig;
import com.virtus.gl.R;
import com.virtus.gl.auth.AuthResult;
import com.virtus.gl.auth.UserProfile;
import com.virtus.gl.auth.VirtusAuthClient;
import com.virtus.gl.util.DeviceUtils;
import com.virtus.gl.util.SessionStore;
import com.virtus.gl.util.TimeFormat;

public class DashboardActivity extends AppCompatActivity {
    private SessionStore session;
    private VirtusAuthClient auth;
    private TextView vipText;
    private TextView accountText;
    private TextView tierText;
    private TextView deviceText;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Runnable heartbeat = new Runnable() {
        @Override
        public void run() {
            refreshProfileAsync(false);
            handler.postDelayed(this, BuildConfig.HEARTBEAT_MS);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);
        session = new SessionStore(this);
        auth = new VirtusAuthClient();

        vipText = findViewById(R.id.vipText);
        accountText = findViewById(R.id.accountText);
        tierText = findViewById(R.id.tierText);
        deviceText = findViewById(R.id.deviceText);
        Button startBtn = findViewById(R.id.startBtn);
        Button stopBtn = findViewById(R.id.stopBtn);
        Button unbindBtn = findViewById(R.id.unbindBtn);
        Button logoutBtn = findViewById(R.id.logoutBtn);

        accountText.setText(session.getUsername());
        tierText.setText(getString(R.string.tier_label, session.getTierName()));
        deviceText.setText(DeviceUtils.getDeviceId());
        updateVipUi(session.getVipTime());

        startBtn.setOnClickListener(v -> {
            if (!isMembershipActive(session.getVipTime())) {
                toast(R.string.membership_expired);
                return;
            }
            toast(R.string.start_stub_message);
        });
        stopBtn.setOnClickListener(v -> toast(R.string.stop_stub_message));
        unbindBtn.setOnClickListener(v -> confirmUnbind());
        logoutBtn.setOnClickListener(v -> {
            session.clearSession();
            startActivity(new Intent(this, LoginActivity.class));
            finish();
        });

        refreshProfileAsync(true);
    }

    @Override
    protected void onResume() {
        super.onResume();
        handler.postDelayed(heartbeat, BuildConfig.HEARTBEAT_MS);
    }

    @Override
    protected void onPause() {
        handler.removeCallbacks(heartbeat);
        super.onPause();
    }

    private void confirmUnbind() {
        new AlertDialog.Builder(this)
                .setTitle(R.string.unbind_title)
                .setMessage(R.string.unbind_message)
                .setPositiveButton(R.string.ok, (d, w) -> new Thread(() -> {
                    AuthResult result = auth.unbind(session.getUsername());
                    runOnUiThread(() -> {
                        if (result.success) {
                            session.clearSession();
                            toast(R.string.unbind_success);
                            startActivity(new Intent(this, LoginActivity.class));
                            finish();
                        } else {
                            toast(result.message);
                        }
                    });
                }).start())
                .setNegativeButton(R.string.cancel, null)
                .show();
    }

    private void refreshProfileAsync(boolean showErrors) {
        String user = session.getUsername();
        if (user == null || user.isEmpty()) {
            return;
        }
        new Thread(() -> {
            UserProfile profile = auth.fetchProfile(user);
            runOnUiThread(() -> {
                if (profile == null) {
                    if (showErrors) {
                        toast(R.string.profile_fetch_failed);
                    }
                    return;
                }
                session.saveProfile(profile);
                updateVipUi(profile.viptime);
            });
        }).start();
    }

    private void updateVipUi(long vipTime) {
        vipText.setText(TimeFormat.remaining(vipTime));
    }

    private boolean isMembershipActive(long vipTime) {
        if (vipTime <= 0) {
            return false;
        }
        return vipTime > (System.currentTimeMillis() / 1000L);
    }

    private void toast(int res) {
        Toast.makeText(this, res, Toast.LENGTH_SHORT).show();
    }

    private void toast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }
}
