using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlurPostEffect : MonoBehaviour {
    public Shader blurShader;
    public Material material;
    private Vector2 blurCenter;
    public float blurFactor;
    void Start () {

        blurCenter = new Vector2 (0.5f, 0.5f);
    }

    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if (material != null) {
            material.SetFloat ("_BlurFactor",blurFactor);
            material.SetVector("_BlurCenter",blurCenter);
            Graphics.Blit (src, dest, material);
        }
    }

}