using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class RenderTextureDemo : MonoBehaviour {
    private Renderer targetRenderer;

    private RenderTexture rt;
    private CommandBuffer commandBuffer;
    private Material material;

    private void OnEnable () {
        if (rt != null) {
            RenderTexture.ReleaseTemporary (rt);
            rt = null;
        }
        if (commandBuffer != null) {
            commandBuffer.Release ();
            commandBuffer = null;
        }
    }

    void Start () {

        MeshRenderer renderer = gameObject.GetComponent<MeshRenderer> ();
        if (material != null) {
            commandBuffer = new CommandBuffer ();

            rt = RenderTexture.GetTemporary (Screen.width, Screen.height, 0);
            commandBuffer.SetRenderTarget (rt);
            commandBuffer.ClearRenderTarget (true, true, Color.black);
            commandBuffer.DrawRenderer (renderer,material);
        }
        else
        {
            enabled = false;
        }
    }

    void Update () {

    }
}