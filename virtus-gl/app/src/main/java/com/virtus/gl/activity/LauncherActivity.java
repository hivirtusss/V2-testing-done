package com.virtus.gl.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.virtus.gl.BuildConfig;
import com.virtus.gl.R;
import com.virtus.gl.util.DeviceUtils;
import com.virtus.gl.util.SessionStore;

public class LauncherActivity extends AppCompatActivity {
    private SessionStore session;
    private TextView progressText;
    private ProgressBar progressBar;
    private LinearLayout versionPanel;
    private LinearLayout progressPanel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launcher);
        session = new SessionStore(this);

        progressPanel = findViewById(R.id.progressPanel);
        versionPanel = findViewById(R.id.versionPanel);
        progressBar = findViewById(R.id.progressBar);
        progressText = findViewById(R.id.progressText);

        findViewById(R.id.tierLite).setOnClickListener(v -> selectTier(1, "lite"));
        findViewById(R.id.tierStandard).setOnClickListener(v -> selectTier(2, "standard"));
        findViewById(R.id.tierPro).setOnClickListener(v -> selectTier(3, "professional"));

        if (!DeviceUtils.isRootAvailable()) {
            new AlertDialog.Builder(this)
                    .setTitle(R.string.root_required_title)
                    .setMessage(R.string.root_required_message)
                    .setPositiveButton(R.string.ok, (d, w) -> finish())
                    .setCancelable(false)
                    .show();
            return;
        }

        runBootstrap();
    }

    private void selectTier(int tier, String name) {
        session.setTier(tier, name);
        versionPanel.setVisibility(View.GONE);
        findViewById(R.id.goLoginBtn).setVisibility(View.VISIBLE);
        Toast.makeText(this, getString(R.string.selected_tier, name), Toast.LENGTH_SHORT).show();
    }

    private void runBootstrap() {
        versionPanel.setVisibility(View.GONE);
        progressPanel.setVisibility(View.VISIBLE);
        progressBar.setIndeterminate(true);

        new Thread(() -> {
            String[] steps = {
                    getString(R.string.step_root),
                    getString(R.string.step_overlay),
                    getString(R.string.step_assets),
            };
            for (int i = 0; i < steps.length; i++) {
                final int step = i + 1;
                final String label = steps[i];
                runOnUiThread(() -> progressText.setText("(" + step + "/" + steps.length + ") " + label));
                if (step == 1) {
                    DeviceUtils.execRoot("id");
                } else if (step == 2) {
                    DeviceUtils.execRoot("appops set --uid " + getPackageName()
                            + " android:system_alert_window allow");
                }
                sleepQuiet(350);
            }
            runOnUiThread(() -> {
                progressPanel.setVisibility(View.GONE);
                versionPanel.setVisibility(View.VISIBLE);
                TextView version = findViewById(R.id.appVersionText);
                version.setText(getString(R.string.app_version_label, BuildConfig.VERSION_NAME));
                findViewById(R.id.goLoginBtn).setOnClickListener(v -> {
                    startActivity(new Intent(this, LoginActivity.class));
                    finish();
                });
            });
        }).start();
    }

    private static void sleepQuiet(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException ignored) {
            Thread.currentThread().interrupt();
        }
    }
}
