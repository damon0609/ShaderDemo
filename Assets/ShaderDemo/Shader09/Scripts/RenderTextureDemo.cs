using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class RenderTextureDemo : MonoBehaviour {
    private Renderer targetRenderer;
    private RenderTexture rt;
    private CommandBuffer commandBuffer;
    public Material replaceMat;

    private void OnEnable () {
        targetRenderer = gameObject.GetComponent<Renderer> ();

        if (commandBuffer == null) {
            commandBuffer = new CommandBuffer ();
            commandBuffer.name = "test";

            rt = new RenderTexture (512, 512, 0, RenderTextureFormat.ARGB32);
            commandBuffer.SetRenderTarget (rt);
            commandBuffer.ClearRenderTarget (true, true, Color.gray);

            Material mat = replaceMat == null? targetRenderer.sharedMaterial : replaceMat;
            mat.mainTexture = rt;
            commandBuffer.DrawRenderer (targetRenderer, mat);
            Camera.main.AddCommandBuffer (CameraEvent.AfterForwardOpaque, commandBuffer);
        }

    }

    private void OnDestroy () {
        if (commandBuffer != null) {
            Camera.main.RemoveCommandBuffer (CameraEvent.AfterForwardOpaque, commandBuffer);
            commandBuffer.Clear ();
            rt.Release ();
        }
    }
}