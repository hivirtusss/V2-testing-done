package com.hivirtus.virtuscontroller

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.hivirtus.virtuscontroller.databinding.FragmentIdentityBinding
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class IdentityFragment : Fragment() {
    private var _binding: FragmentIdentityBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentIdentityBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.btnGenerateId.setOnClickListener {
            binding.androidIdInput.setText(IdentityConfig.randomId())
        }
        binding.btnSaveIdentity.setOnClickListener { save() }
        refreshSelection()
    }

    fun refreshSelection() {
        val b = _binding ?: return
        val pkg = SelectionHolder.selectedPackage
        if (pkg == null) {
            b.selectedPkgLabel.text = "Select an app from Apps tab"
            return
        }
        b.selectedPkgLabel.text = "${SelectionHolder.selectedLabel}\n$pkg"
        viewLifecycleOwner.lifecycleScope.launch {
            val cfg = withContext(Dispatchers.IO) { IdentityConfig.load(pkg) }
            _binding?.androidIdInput?.setText(cfg.androidId)
            _binding?.signatureSwitch?.isChecked = cfg.signatureSpoofEnabled
            _binding?.signatureHashInput?.setText(cfg.signatureSha256)
        }
    }

    private fun save() {
        val pkg = SelectionHolder.selectedPackage
        if (pkg == null) {
            Toast.makeText(requireContext(), "Select an app first", Toast.LENGTH_SHORT).show()
            return
        }
        val id = binding.androidIdInput.text.toString().trim().lowercase()
        if (id.length != 16 || !id.all { it in "0123456789abcdef" }) {
            Toast.makeText(requireContext(), "Android ID must be 16 hex chars", Toast.LENGTH_SHORT).show()
            return
        }
        val cfg = IdentityConfig(
            packageName = pkg,
            androidId = id,
            signatureSpoofEnabled = binding.signatureSwitch.isChecked,
            signatureSha256 = binding.signatureHashInput.text.toString().trim().lowercase()
        )
        viewLifecycleOwner.lifecycleScope.launch {
            val r = withContext(Dispatchers.IO) { IdentityConfig.save(cfg) }
            Toast.makeText(
                requireContext(),
                if (r.ok) "Saved — ZIP module will apply on next app open" else "Failed: ${r.stderr.ifBlank { r.stdout }}",
                Toast.LENGTH_LONG
            ).show()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
