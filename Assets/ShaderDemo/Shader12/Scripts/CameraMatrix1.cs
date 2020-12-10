using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMatrix1 : MonoBehaviour
{
    private Camera mCamera;
    [SerializeField] Material material;

    private Vector3 mCameraPos;
    private float farDistance;
    private float halfHeight;
    private float halfWidth;

    private Vector3 mCameraForward;
    private Vector3 mCameraRight;
    private Vector3 mCameraUp;

    Vector3 farPlaneCenter;
    Vector3 leftTop;
    Vector3 leftBottom;
    Vector3 rightTop;
    Vector3 rightBottom;

    private int vCol;
    void Start()
    {

        vCol = Shader.PropertyToID("vcol");
        mCamera = gameObject.GetComponent<Camera>();
        mCamera.depthTextureMode = DepthTextureMode.Depth;
        farDistance = mCamera.farClipPlane;
        mCameraPos = transform.position;

        mCameraForward = transform.forward;
        mCameraRight = transform.right;
        mCameraUp = transform.up;

        farPlaneCenter = mCameraPos + mCameraForward.normalized * farDistance;


    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, material);
    }

    private void OnPreRender()
    {
        halfHeight = farDistance * Mathf.Tan(mCamera.fieldOfView * 0.5f * Mathf.Deg2Rad);
        halfWidth = halfHeight * mCamera.aspect;

        leftTop = farPlaneCenter + new Vector3((-mCameraRight * halfWidth).x, (mCameraUp * halfHeight).y, 0);
        leftBottom = farPlaneCenter + new Vector3((-mCameraRight * halfWidth).x, (-mCameraUp * halfHeight).y, 0);
        rightTop = farPlaneCenter + new Vector3((mCameraRight * halfWidth).x, (mCameraUp * halfHeight).y, 0);
        rightBottom = farPlaneCenter + new Vector3((mCameraRight * halfWidth).x, (-mCameraUp * halfHeight).y, 0);

        Vector4 leftTopRay = leftTop - mCameraPos;
        Vector4 leftBottomRay = leftBottom - mCameraPos;
        Vector4 rightTopRay = rightTop - mCameraPos;
        Vector4 rightBottomRay = rightBottom - mCameraPos;

        Matrix4x4 matrix = new Matrix4x4();
        matrix.SetRow(0, leftBottomRay);
        matrix.SetRow(1, leftTopRay);
        matrix.SetRow(2, rightTopRay);
        matrix.SetRow(3, rightBottomRay);

        material.SetMatrix(vCol, matrix);
    }
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(mCameraPos, 1f);
        Gizmos.DrawSphere(farPlaneCenter, 1f);


        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(leftTop, 1f);
        Gizmos.DrawSphere(leftBottom, 1f);
        Gizmos.DrawSphere(rightTop, 1f);
        Gizmos.DrawSphere(rightBottom, 1f);


        Gizmos.color = Color.blue;
        Gizmos.DrawLine(mCameraPos, farPlaneCenter);
        Gizmos.DrawLine(mCameraPos, mCameraPos + mCameraRight.normalized * halfWidth);
        Gizmos.DrawLine(mCameraPos, mCameraPos + mCameraUp.normalized * halfHeight);


    }
}