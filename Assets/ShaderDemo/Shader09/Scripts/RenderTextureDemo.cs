using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class RenderTextureDemo : MonoBehaviour
{
    private Renderer targetRenderer;
    private RenderTexture rt;
    private CommandBuffer commandBuffer;
    public Material material;
    public Material effectMat;

    public Color outLineColor;
    public int outLineSize;

    public int blurSize = 2;

    public GameObject targetObj;

    private void OnEnable()
    {
        if (rt != null)
        {
            RenderTexture.ReleaseTemporary(rt);
            rt = null;
        }
        if (commandBuffer != null)
        {
            commandBuffer.Release();
            commandBuffer = null;
        }
    }
    void Start()
    {
        Renderer renderer = targetObj.GetComponent<Renderer>();
        if (material != null)
        {
            commandBuffer = new CommandBuffer();
            commandBuffer.name = "ReplaceMat";
            rt = RenderTexture.GetTemporary(512, 512, 0);
            commandBuffer.SetRenderTarget(rt);
            commandBuffer.ClearRenderTarget(true, true, Color.gray);
            commandBuffer.DrawRenderer(renderer, material);
            renderer.sharedMaterial.mainTexture = rt;
            Camera.main.AddCommandBuffer(CameraEvent.AfterForwardOpaque, commandBuffer);
        }
        else
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (rt != null && material != null && commandBuffer != null)
        {
            material.SetColor("_OutLineColor", outLineColor);
            // Graphics.ExecuteCommandBuffer(commandBuffer);
            Graphics.Blit(rt, dest);

            // RenderTexture temp1 = RenderTexture.GetTemporary(src.width, src.height, 0);
            // RenderTexture temp2 = RenderTexture.GetTemporary(src.width, src.height, 0);

            // effectMat.SetInt("_outLineSize", outLineSize);

            // Graphics.Blit(rt, temp1, effectMat, 0);
            // Graphics.Blit(temp1, temp2, effectMat, 1);

            // for (int i = 0; i < blurSize; i++)
            // {
            //     Graphics.Blit(temp2, temp1, effectMat, 0);
            //     Graphics.Blit(temp1, temp2, effectMat, 1);
            // }

            // effectMat.SetTexture("_renderTex", rt);
            // Graphics.Blit(temp2, temp1, effectMat, 2);

            // effectMat.SetTexture("_outLineTex", temp1);
            // Graphics.Blit(src, dest, effectMat, 3);

            // RenderTexture.ReleaseTemporary(temp1);
            // RenderTexture.ReleaseTemporary(temp2);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
    void Update()
    {

    }

    private void OnDisable()
    {

        if (commandBuffer != null)
        {
            Camera.main.RemoveCommandBuffer(CameraEvent.AfterForwardOpaque, commandBuffer);
            commandBuffer.Clear();
        }
        if (rt != null)
            rt.Release();
    }
}