using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMatrix : MonoBehaviour
{

    private Camera mCamera;
    private Matrix4x4 cameraToProjectionMatrix;
    private Matrix4x4 worldToCameraMatrix;
    private Vector3 worldPos = Vector3.one;
    private Vector3 screenPos;
    [SerializeField] Material material;

    void Start()
    {
        mCamera = gameObject.GetComponent<Camera>();
        mCamera.depthTextureMode = DepthTextureMode.Depth;
        //通过计算相机的投影矩阵计算出gpu的投影矩阵
        cameraToProjectionMatrix = GL.GetGPUProjectionMatrix(mCamera.projectionMatrix, false);
        worldToCameraMatrix = mCamera.worldToCameraMatrix; //将世界中的点转换成观察空间即相机空间的点

        //将世界空间中的点转换为相机投影空间中的点，矩阵从右向左运算
        Matrix4x4 worldToCameraProjection = cameraToProjectionMatrix * worldToCameraMatrix;
        screenPos = worldToCameraProjection * worldPos;

        Debug.Log("世界to屏幕空间\n" + worldToCameraProjection.ToString());

        //将屏幕空间中的坐标点转换成世界空间中的点
        Matrix4x4 cameraProjectionToWorld = worldToCameraProjection.inverse;

        material.SetMatrix("_CameraProjectionToWorld", cameraProjectionToWorld);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, material);
    }

}