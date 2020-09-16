using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


public class CommandBuffer01 : MonoBehaviour
{
    public Material replaceMat;
    private CommandBuffer commandBuffer;
    private Renderer targetRender;
    private RenderTexture rt;

    void Start()
    {
        targetRender = gameObject.GetComponent<Renderer>();

        if (rt == null)
        {
            rt = RenderTexture.GetTemporary(512, 512, 16, RenderTextureFormat.BGRA32, 0);
        }

        if (commandBuffer != null)
            commandBuffer.Clear();
        else
            commandBuffer = new CommandBuffer();

        commandBuffer.ClearRenderTarget(true, true, Color.gray);
        commandBuffer.SetRenderTarget(rt);

        Material temp = replaceMat ? replaceMat : targetRender.sharedMaterial;
        temp.mainTexture = rt;
        commandBuffer.DrawRenderer(targetRender, temp);
        Camera.main.AddCommandBuffer(CameraEvent.AfterForwardOpaque, commandBuffer);
    }

    private void OnDisable()
    {
        if (commandBuffer != null)
        {
            Camera.main.RemoveCommandBuffer(CameraEvent.AfterForwardOpaque,commandBuffer);
            commandBuffer.Clear();
            commandBuffer = null;
        }

        if(rt!=null)
        {
            rt.Release();
        }
    }
    void Update()
    {

    }
}
