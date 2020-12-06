using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenPostEffect : MonoBehaviour {
    public Material material;

    bool valid = false;
    Camera _camera;
    void Start () {
        _camera = gameObject.GetComponent<Camera> ();
        if (_camera != null) {
            valid = true;
            _camera.depthTextureMode = DepthTextureMode.DepthNormals;
        }
    }
    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if (material == null || !valid)
            Graphics.Blit (src, dest);
        else {
            Graphics.Blit (src, dest, material);
        }
    }
}